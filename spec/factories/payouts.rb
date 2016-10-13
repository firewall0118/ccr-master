# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payout do

    contract
    amount_cents        {rand(45000) + 5000}
    invoice_date  Date.today

  end
end
