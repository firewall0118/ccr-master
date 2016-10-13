# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :family do

    first_parent_name                { Faker::Name.first_name }
    first_parent_last_name           { Faker::Name.last_name }
    first_parent_race                { ChildcareResource::RACES.sample }
    first_parent_sex                 { ChildcareResource::GENDERS.sample }
    first_parent_date_of_birth       30.years.ago
    first_parent_residence_county    { County.all.sample }
    first_parent_first_job_average_hours_worked 40

    second_parent_name               { Faker::Name.first_name }
    second_parent_last_name          { Faker::Name.last_name }

    after(:create) do |family, transient|
      create(:address, settler: family)
    end


  end
end
