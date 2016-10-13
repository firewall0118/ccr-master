class Funder < ActiveRecord::Base
  include FunderCSV

  validates :name, :address, presence: true

  has_many :funding_cycles
  has_many :supported_counties
  has_many :counties, :through => :supported_counties

  has_many :contracts, -> { where.not({ status: :inactive }) }, through: :funding_cycles
  has_many :payouts, through: :funding_cycles

  accepts_nested_attributes_for :supported_counties
  accepts_nested_attributes_for :funding_cycles, allow_destroy: true

  def last_contract_date
    latest = contracts.latest.first
    "#{latest.start_date.to_s} - #{latest.end_date.to_s}" if latest.present?
  end

  def children_funded
    contracts.select('DISTINCT child_id').size
  end

  def balance
    total_funded - spent
  end

  # TODO cache in column
  def total_funded
      total = 0
      cycles = funding_cycles
      cycles.each do |cycle|
        total += cycle.amount
      end
      total
  end

  alias_method :funded, :total_funded

  def spent(year=nil, month=nil)
    if year.present? && month.present?
      date = Date.new(year.to_i, month.to_i)
      payouts.where(created_at: date.beginning_of_month..date.end_of_month).sum(:amount)
    else
      payouts.sum(:amount)
    end
  end

  def amount!
    funding_cycles.sum :amount
  end

  def update_amount
    update_column :amount, amount!
  end

  private

  def self.number_to_currency(value)
    ActionController::Base.helpers.number_to_currency(value)
  end
end
