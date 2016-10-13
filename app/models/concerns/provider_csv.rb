module ProviderCSV
  extend ActiveSupport::Concern
  included do

    # to export monthly provider payment method
    def self.to_csv(options = {}, params={})
      CSV.generate do |csv|
        header = [
          "Provider Id",
          "Provider Name",
          "Address",
          "City",
          "State",
          "Zipcode",
          "Amount Owed to Provider",
        ]
        header.push("Paid Amount") if params[:payment_report]
        csv << header

        all.each do |provider|
          fields = [
            provider.id,
            provider.name,
            provider.physical_address_street,
            provider.physical_address_city,
            provider.physical_address_state,
            provider.physical_address_zip,
            ActionController::Base.helpers.number_to_currency(provider.payment_outstanding),
          ]
          if params[:payment_report]
            fields.push(ActionController::Base.helpers.number_to_currency provider.paid_amount)
          end
          csv << fields
        end
      end
    end

    def self.children_per_provider
      CSV.generate do |csv|
        all.each do |provider|
          header = [
            "Provider Name",
            provider.name,
            "Number of Children",
            provider.children.count
          ]
          csv << header
          csv << [""]
          children_header = [
            "ID",
            "Name",
            "Age",
            "Age Group"
          ]
          csv << children_header

          provider.children.each do |child|
            fields = [
              child.id,
              child.full_name,
              child.current_age,
              child.age_group.try(:name)
            ]
            csv << fields
          end
          csv << [""]
          csv << [""]
        end
      end
    end
  end
end
