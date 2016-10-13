# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :provider do

      name                    { Faker::Name.name }
      director_name           { "Dir. #{Faker::Name.name}" }
      physical_address_street { Faker::Address.street_address }
      physical_address_city   { Faker::Address.city }
      physical_address_state  { Faker::Address.state }
      physical_address_zip    { Faker::Address.zip }
      county                  { County.all.sample } # nil unless seed
      phone_number            { Faker::PhoneNumber.phone_number }
      provider_type           { ProviderType.all.sample } # nil unless seed
      provider_license_type   'type'
    end
  end
