class Contract < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  acts_as_paranoid
  
  # Associations
  belongs_to :child
  belongs_to :provider, counter_cache: :children_count
  belongs_to :funding_cycle
  has_one    :family, through: :child, dependent: :destroy
  has_one    :funder, through: :funding_cycle, dependent: :destroy
  has_many   :payouts, dependent: :destroy
  has_many   :provider_attendances, dependent: :destroy

  validates_presence_of :provider,
                        :child,
                        :funding_cycle
  validates_inclusion_of :is_full_time, :in => [true, false]

  # validate :validate_funder, on: :create

  validates_date :start_date, before: :end_date
  validate :check_dates, on: :update
  validate :check_age_group, on: :create

  before_create :calculate_fees
  after_save :build_provider_attendance

  scope :current,     -> { where("? BETWEEN start_date AND end_date", Date.today) }
  scope :latest,      -> { order("start_date desc").limit(1) }
  scope :upcoming,    -> { where("start_date > ?", Date.today + 1.day) }
  scope :by_provider, -> (provider_id) { where(provider_id: provider_id) }
  scope :by_child,    -> (child_id) { where(child_id: child_id) }
  scope :by_funder,   -> (funder_id) { joins(:funding_cycle).where(funding_cycles: {funder_id: funder_id}) }
  scope :active,      -> { where.not({ status: :inactive}) }

  scope :in_month, -> (year, month) do
    date = Date.new(year.to_i, month.to_i).strftime('%Y%m')
    where("to_char(start_date, 'YYYYMM') <= ? and to_char(end_date, 'YYYYMM') >= ?", date, date)
  end
  
  scope :between, -> (start_date, end_date) do
    where("DATE_PART('day', start_date::timestamp - ?::timestamp) " +
      "* DATE_PART('day', ?::timestamp - end_date::timestamp) >= 0",
      end_date, start_date)
  end

  scope :overlaps,    -> (contract) do
    where("DATE_PART('day', start_date::timestamp - ?::timestamp) " +
      "* DATE_PART('day', ?::timestamp - end_date::timestamp) >= 0",
      contract.end_date, contract.start_date)
      .where('id != ?', contract.id || -1)
  end

  def self.earlist
    sql = %Q(? BETWEEN start_date AND end_date OR start_date > ?)
    where(sql, Date.today, Date.tomorrow).order(:start_date)
  end
  
  def validate_funder
    current_contracts = Contract.current.by_child(child_id)
    if current_contracts.where(funding_cycle_id: funding_cycle_id).present?
      errors.add(:child_id, "has already been taken with selected funding cycle")
    end
  end

  def self.in_fiscal_year
    current_setting = Setting.first

    contracts = where("start_date > ? AND end_date < ?",
      current_setting.fiscal_year_start,
      current_setting.fiscal_year_end
    )
  end

  def self.fiscal_year
    CSV.generate do |csv|
      header = [
        "Child Name",
        "Custodian(s)",
        "Provider",
        "Funder",
        "Period",
        "Subsidy"
      ]

      csv << header

      all.each do |contract|
        fields = [
          contract.child.full_name,
          contract.family.name,
          contract.provider.name,
          contract.funder.name,
          "#{contract.start_date.to_s} ~ #{contract.end_date.to_s}",
          ActionController::Base.helpers.number_to_currency(contract.total_subsidy)
        ]
        csv << fields
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate do |csv|
      header = [
        'Family',
        'Child',
        'Provider',
        'Funder',
        'Weekly Parent Fee',
        'Weekly Subsidy',
        'Discount',
        'Status',
        'Start date',
        'End date'
      ]

      csv << header

      all.each do |contract|
        fields = [
          contract.family.name,
          contract.child.full_name,
          contract.provider.name,
          contract.funder.name,
          ActionController::Base.helpers.number_to_currency(contract.weekly_parent_fee),
          ActionController::Base.helpers.number_to_currency(contract.weekly_subsidy),
          ActionController::Base.helpers.number_to_currency(contract.discount),
          contract.start_date,
          contract.end_date,
          contract.state
        ]
        csv << fields
      end
    end
  end

  def dates_present?
    start_date.present? and end_date.present?
  end

  def daily_rate
    weekly_rate / 5.0
  end

  def child_name
    child.try(:full_name)
  end

  def current?
    if dates_present?
      Date.today.between? start_date.to_date, end_date.to_date
    end
  end

  def future?
    start_date.to_date > Date.today if start_date.present?
  end

  def state
    if current?
      'Current'
    elsif future?
      'Upcoming'
    else
      'Past'
    end
  end

  def period
    "#{start_date} ~ #{end_date}"
  end

  def total_subsidy(year=nil, month=nil)
    date = year && month ? Date.new(year, month) : nil
    days_attended(year, month) * weekly_subsidy / 5.0
  end

  def total_amount(year=nil, month=nil)
    days_attended(year, month) * daily_rate
  end

  def total_parent_fee(year=nil, month=nil)
    date = year && month ? Date.new(year, month) : nil
    days_attended(year, month) * weekly_parent_fee / 5.0
  end

  def days_attended(year=nil, month=nil)
    if year && month
      # total attended days in this month
      provider_attendances.by_year(year).by_month(month).sum(:days)
    else
      provider_attendances.sum(:days)
    end
  end

  def rate_source
    provider.rate_source(child.age_group.try(:name), is_full_time?)
  end

  def check_dates
    contracts_of_child = Contract.where(child_id: child_id).where.not(id: id)
    if closest_end_date = contracts_of_child.where("end_date > ? and start_date < ?", start_date, start_date).maximum(:end_date)
      errors.add(:start_date, "should be after #{closest_end_date}")
    elsif closest_start_date = contracts_of_child.where("start_date < ? and end_date > ?", end_date, end_date).minimum(:start_date)
      errors.add(:end_date, "should be before #{closest_start_date}")
    end
  end

  def check_age_group
    errors.add(:base, "There is no age group for this child. Check age group setting.") if child.age_group.nil?
  end

  def calculate_fees
    rate = provider.get_efficient_rate(child.age_group.try(:name), is_full_time?)
    weekly_rate = (rate - (self.discount.nil? ? 0 : self.discount))

    self.weekly_rate = weekly_rate
    self.weekly_parent_fee = (weekly_rate * family.parent_fee_percent(self.start_date)).round
    self.weekly_subsidy = self.weekly_rate - self.weekly_parent_fee
  end

  def build_provider_attendance
    if start_date_changed? or end_date_changed?
      date = start_date.beginning_of_month

      sql = "TO_DATE(CONCAT(year, LPAD(''||month, 2, '0')), 'YYYYMM') BETWEEN ? AND ?"
      invalid_eavs = provider_attendances.where.not(sql, date, end_date)
      invalid_eavs.destroy_all
      while date < end_date
        attendance = provider_attendances.find_by({month: date.month, year: date.year})
        provider_attendances.create({
          provider: provider,
          year: date.year,
          month: date.month
        }) unless attendance
        date += 1.month
      end
    end
  end
end
