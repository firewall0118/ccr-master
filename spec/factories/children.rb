# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :child do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    date_of_birth         { Date.today - (rand(6) + 1).years }
    gender                { ChildcareResource::GENDERS.sample }
    race                  { ChildcareResource::RACES.sample }
    relationship          { %w[Son Daughter].sample }
    family
    weekly_maximum_payout 100
  end
end
