# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :funder do
    email           { Faker::Internet.email }
    name            { Faker::Name.name }
    address         { Faker::Address.street_address }
    phone_number    { Faker::PhoneNumber.phone_number }
    contact_person  { Faker::Name.name }
    active          { [true, false].sample }
    amount          { rand(50000) + 1000 }
    max_family_size { rand(5) + 1 }
  end
end
