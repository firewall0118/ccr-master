module FunderCSV
  extend ActiveSupport::Concern
  included do
    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << [
          "Funder Name",
          "Number of Families",
          "Average Number of Children",
          "Average Income per Family",
        ]

        all.each do |funder|
          families = funder.contracts.select("distinct(child_id)").map(&:family)
          average_income = families.sum(&:number_of_custodian) == 0 ? 0 : families.sum(&:annual_income) / families.sum(&:number_of_custodian)
          csv << [
            funder.name,
            families.count,
            families.empty? ? 0 : families.sum(&:number_of_children) / families.count.to_f,
            number_to_currency(average_income)
          ]
        end
      end
    end

    def self.balance_sheet
      CSV.generate do |csv|
        header = [
          "Funder Name",
          "Funded",
          "Spent",
          "Balance",
          "Children Funded"
        ]

        csv << header

        all.each do |funder|
          csv << [
            funder.name,
            number_to_currency(funder.funded),
            number_to_currency(funder.spent),
            number_to_currency(funder.balance),
            funder.children_funded
          ]
        end
      end
    end
  end
end
