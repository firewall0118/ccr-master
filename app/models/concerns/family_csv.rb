module FamilyCSV
  extend ActiveSupport::Concern
  included do
    # to export monthly provider payment method
    def self.to_csv(options = {}, params={})
      CSV.generate do |csv|
        header = [
          "Application Date",
          "First Parent",
          "Second Parent",
          "Number of Children",
          "Annual Income",
          "Parent Fee",
          "Redetermination Due Date",
        ]

        csv << header

        all.each do |family|
          fields = [
            family.created_at.strftime("%b/%d/%Y"),
            family.first_parent.try(&:full_name),
            family.second_parent.try(&:full_name),
            family.children_count,
            ActionController::Base.helpers.number_to_currency(family.annual_income),
            family.parent_fees,
            family.redetermination_due_date
          ]
          csv << fields
        end
      end
    end

    def self.redetermination_due_csv(options = {}, params = {})
      CSV.generate do |csv|
        header = [
          "ID",
          "Parents",
          "Children",
          "Funders",
          "Providers",
          "Annual Income",
          "Redetermination Due Date",
        ]

        csv << header

        all.each do |family|
          fields = [
            family.id,
            family.name,
            family.children.map(&:full_name).join(", "),
            family.contracts.map(&:funder).map(&:name).join(", "),
            family.providers.pluck(:name).uniq.join(', '),
            ActionController::Base.helpers.number_to_currency(family.annual_income, precision: 0),
            family.redetermination_due_date
          ]
          csv << fields
        end
      end
    end
  end
end
