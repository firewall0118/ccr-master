class Provider < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include ProviderCSV
  
  ### Associations

  has_many :contracts, -> { where.not({ status: :inactive }) }, dependent: :destroy
  has_many :children, through: :contracts

  # rates
  has_many :provider_rates

  has_many :provider_attendances
  has_many :payouts, through: :provider_attendances
  accepts_nested_attributes_for :provider_rates, allow_destroy: true

  belongs_to :county
  belongs_to :provider_type

  ### Validations

  validates :name,
            :director_name,
            :physical_address_street,
            :physical_address_city,
            :physical_address_state,
            :physical_address_zip,
            :phone_number,
            :vendor_number,
            :provider_type_id,
            :county_id,
            :provider_license_type, presence: true

  def location
    "#{physical_address_city}, #{physical_address_state} #{physical_address_zip}"
  end

  def street
    mailing_address_street.present? ? mailing_address_street : physical_address_street
  end

  def mailing_address
    address = "#{mailing_address_city}, #{mailing_address_state} #{mailing_address_zip}"
    if address == ',  '
      address = location
    end
    address
  end

  def active_provider_rate
    provider_rates.last || ProviderRate.new(provider_id: id)
  end

  def number_of_children
    contracts.count('DISTINCT child_id')
  end

  def unique_children
    children.select('DISTINCT children.id, children.*')
  end

  def current_rate
    provider_rates.last
  end

  def payment_outstanding(year=nil, month=nil)
    if year && month
      attendances = provider_attendances.pending.where(year: year, month: month)
    else
      attendances = provider_attendances.pending
    end
    attendances.includes(contract: [:provider, :child]).map{|at| at.contract.weekly_rate * at.days}.inject(0, :+)
  end

  def paid_amount(year=nil, month=nil)
    if year && month
      attendances = provider_attendances.closed.where(year: year, month: month)
    else
      attendances = provider_attendances.closed
    end
    Payout.joins(:provider_attendance).where(provider_attendance_id: attendances.map(&:id)).sum(:amount)
  end

  def closed_months
    provider_attendances.where(closed: true).map(&:month)
  end

  def total_amount
    payment_outstanding + paid_amount
  end

  def rate_source(age_group, is_full_time)
    rates = provider_rates.last
    average_rate = CountyRate.where(county: county, provider_type_id: provider_type_id).first

    ft = is_full_time ? 'full_time' : 'part_time'
    if rates.nil?
      provider_rate = 1000000
    else
      provider_rate = rates.send("#{ft}_#{age_group.underscore}_weekly_rate")
      provider_rate = provider_rate.nil? ? 100000 : provider_rate.to_f
    end
    avg_rate = average_rate.send("#{ft}_#{age_group.underscore}_weekly_rate").to_f
    if avg_rate <= provider_rate
      average_rate.county.name
    else
      name
    end
  end

  def get_efficient_rate(age_group, is_full_time)
    rates = provider_rates.last
    average_rate = CountyRate.where(county: county, provider_type_id: provider_type_id).first

    ft = is_full_time ? 'full_time' : 'part_time'
    if rates.nil?
      provider_rate = 1000000
    else
      provider_rate = rates.send("#{ft}_#{age_group.underscore}_weekly_rate")
      provider_rate = provider_rate.nil? ? 100000 : provider_rate.to_f
    end
    avg_rate = average_rate.send("#{ft}_#{age_group.underscore}_weekly_rate").to_f
    [provider_rate, avg_rate].min
  end

  def start_date(family)
    contracts.by_child(family.children.pluck(:id)).minimum :start_date
  end

  def end_date(family)
    contracts.by_child(family.children.pluck(:id)).maximum :end_date
  end
end
