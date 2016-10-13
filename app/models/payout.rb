class Payout < ActiveRecord::Base
  belongs_to :contract
  belongs_to :funding_cycle
  belongs_to :provider_attendance

  validates_presence_of :funding_cycle, :contract
end
