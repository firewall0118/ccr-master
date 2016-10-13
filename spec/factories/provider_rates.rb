# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :provider_rate do

    part_time_toddler_weekly_rate_cents  1000
    part_time_infant_weekly_rate_cents  1000
    part_time_school_weekly_rate_cents 1000
    part_time_preschool_weekly_rate_cents  1000
    part_time_sibling_discount_flat_amount_cents 200
    part_time_sibling_discount_percentage           { rand(25) + 1 }
    full_time_toddler_weekly_rate_cents 2000
    full_time_infant_weekly_rate_cents 2000
    full_time_school_weekly_rate_cents 2000
    full_time_preschool_weekly_rate_cents 2000
    full_time_sibling_discount_flat_amount_cents 0
    full_time_sibling_discount_percentage           { rand(25) + 1 }


    trait :past do
       effective_date { 2.months.ago }
       end_date {  1.weeks.ago - 1.day  }

    end

    trait :current do
      effective_date { 1.weeks.ago }
      end_date { 3.weeks.from_now  }
    end

    trait :future do
      effective_date { 3.weeks.from_now + 1.days }
    end

    factory :past_rates , traits: [:past]
    factory :current_rates , traits: [:current]
    factory :future_rates , traits: [:future]
  end
end
