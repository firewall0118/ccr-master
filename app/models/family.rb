class Family < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include FamilyCSV
  extend Enumerize
  acts_as_paranoid

  has_many :children, dependent: :destroy
  has_many :contracts, through: :children, dependent: :destroy
  has_many :current_contracts, through: :children
  has_many :family_notes, dependent: :destroy
  has_many :providers, through: :contracts

  has_many :parents, dependent: :destroy

  has_one  :first_parent,  -> { where order: 'first' }, class_name: "Parent"
  has_one  :second_parent, -> { where order: 'second' }, class_name: "Parent"

  default_scope { includes(:first_parent, :second_parent) }

  scope :accepted, -> { joins(:contracts).where('? BETWEEN contracts.start_date AND contracts.end_date', Date.today).uniq }
  scope :in_process, -> { joins(:contracts).where("contracts.start_date = NULL AND contracts.end_date = NULL").uniq }
  scope :denied, -> { where(status: :denied) }

  validates_date :redetermination_due_date, after: :today, allow_blank: true

  REJECT_REASONS = [
    :over_income,
    :under_income,
    :information_falsification,
    :below_hours_requirement,
    :incomplete_application,
    :other
  ]

  enumerize :rejection_reason, in: REJECT_REASONS,
                            scope: true,
                            predicates: { prefix: true }
  enumerize :status, in: %w(initial redeterminated denied),
                            scope: true,
                            predicates: { prefix: true },
                            default: :initial,
                            i18n_scope: "enumerize.family.status"

  def parent_fees
    current_contracts.includes(family: [parents: :versions])
      .map { |c| number_to_currency c.weekly_parent_fee }
      .join(', ').presence || 'N/A'
  end

  def is_within_income_scale?(update = false)
    scale.present?
  end

  def eligible?
    eligibility = weekly_availability >= 35
    eligibility = eligibility && is_within_income_scale? and children_count > 0

    return eligibility
  end

  def weekly_availability
    res = first_parent.weekly_availability
    res += second_parent.try(:weekly_availability) if second_parent && second_parent.has_custody
    res
  end

  def size
    # First parent counts as one family member.
    family_size = 1
    if second_parent.try(:has_custody)
      # If second parent has custody count her in as well.
      family_size += 1
    end
    family_size += children.size
  end

  def number_of_children
    children.size
  end

  def redetermination_periods
    return [] if contracts.empty?
    versions = PaperTrail::Version.where(item: parents)
    dates = versions.map(&:active_at).compact
    dates.push(created_at)
    dates.push(contracts.maximum :end_date)
    dates = dates.sort

    periods = Array.new
    dates.each_with_index do |date, i|
      next if i == 0
      periods.push [dates[i-1], dates[i]]
    end
    periods
  end

  def annual_income(applied_at=Time.now)
    if second_parent.present? && second_parent.has_custody?
      [first_parent.annual_income(applied_at), second_parent.annual_income(applied_at)].compact.inject(0, :+)
    else
      first_parent.annual_income(applied_at)
    end
  end

  def number_of_custodian
    if second_parent.try(:has_custody)
      # If second parent has custody count her in as well.
      2
    else
      1
    end
  end

  def parent_fee_percent(calculated_at)
    annual_income(calculated_at) / Scale.max_for_family_size(size)
  end

  def initial_application?
    contracts.present?
  end

  def period_start(provider=nil)
    if provider
      format_date(contracts.by_provider(provider.id).minimum :start_date)
    else
      format_date(contracts.minimum :start_date)
    end
  end

  def term
    "#{contracts.minimum :start_date} - #{contracts.maximum :start_date}"
  end

  def period_end(provider=nil)
    if provider
      format_date(contracts.by_provider(provider.id).maximum :end_date)
    else
      format_date(contracts.maximum :end_date)
    end
  end

  def format_date(date)
    date.strftime("%b %e, %Y")
  end

  def first_parent=(params)
    params.permit!
    if first_parent.nil?
      params[:family_id] = id
      params[:order] = :first
      parent = Parent.create(params)
      errors.messages.merge!(first_parent: parent.errors.messages) if parent.errors.messages.present?
    else
      first_parent.update_attributes(params)
      errors.messages.merge!(first_parent: first_parent.errors.messages) if first_parent.errors.messages.present?
    end
  end

  def second_parent=(params)
    return if params.nil? || params[:first_name].empty?
    params.permit!
    if second_parent.nil?
      params[:family_id] = id
      params[:order] = :second
      parent = Parent.create(params)

      errors.messages.merge!(second_parent: parent.errors.messages) if parent.errors.messages.present?
    else
      second_parent.update_attributes(params)
      errors.messages.merge!(second_parent: second_parent.errors.messages) if second_parent.errors.messages.present?
    end
  end

  def name
    [first_parent.last_name, second_parent.try(:last_name)].compact.join(", ")
  end

  def scale
    Scale.matched_scale(size, annual_income)
  end
end
