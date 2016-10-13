# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :funding_cycle do
    amount        { rand(10000) + 100_000 }
    start_date    { Date.today + (rand(30) - 1).days }
    end_date      { start_date + 2.months }
    funder        { Funder.all.sample || FactoryGirl.create(:funder) }
  end
end
