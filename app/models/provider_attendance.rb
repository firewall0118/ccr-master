class ProviderAttendance < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :provider
  belongs_to :contract
  has_many :payouts

  validates :days, numericality: { greater_than_or_equal_to: 0 }

  scope :closed, -> { where("closed = true AND days > 0") }
  scope :pending, -> { where("closed = false AND days > 0") }
  scope :by_year, -> year { where(year: year) }
  scope :by_month, -> month { where(month: month) }
  scope :by_provider, -> provider_id { where(provider_id: provider_id) }
  scope :by_paid_at, -> date { includes(:payouts).where(payouts: {created_at: date.beginning_of_month..date.end_of_month}) }
  scope :upcoming, -> (year, month) { where("year >= :year OR (year = :year AND month > :month)", year: year, month: month) }
  scope :outstanding, -> (year, month) { where("closed = false AND (year <= :year OR (year = :year AND month <= :month))", year: year, month: month) }
end
