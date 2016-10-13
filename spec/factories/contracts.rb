# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contract do
    start_date    { Date.today }
    end_date      { Date.today + rand(15).days + 15.days }
  end
end
