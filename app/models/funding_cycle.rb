class FundingCycle < ActiveRecord::Base

  belongs_to :funder
  has_many :contracts
  has_many :payouts

  validates :amount,  :numericality => { :greater_than => 0 }
  validates_date :start_date, before: :end_date

  after_save do
    funder.update_amount
  end

  def to_s
    "#{start_date} to #{end_date}"
  end

  def self.to_csv(options={})
    CSV.generate(options) do |csv|
      all.each do |cycle|
        cycle_header = [
          "FUNDER:",
          cycle.funder.name,
          "PERIOD: ",
          cycle.to_s,
          "TOTAL",
          ActionController::Base.helpers.number_to_currency(cycle.amount)
        ]
        csv << cycle_header

        header = [
          "Child Name",
          "Custodian(s)",
          "Provider",
          "Funder",
          "Period",
          "Subsidy"
        ]

        csv << header
        cycle.contracts.each do |contract|
          fields = [
            contract.child.full_name,
            contract.family.name,
            contract.provider.name,
            contract.funder.name,
            "#{contract.start_date} ~ #{contract.end_date}",
            ActionController::Base.helpers.number_to_currency(contract.total_subsidy)
          ]
          csv << fields
        end
        csv << []
      end
    end
  end
end
