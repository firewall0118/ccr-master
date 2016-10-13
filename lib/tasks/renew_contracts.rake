namespace :contracts do
  desc 'Recalculate the contract fees'
  task recalculate_fees: :environment do
    @contracts = Contract.all
    @contracts.each do |contract|
      contract.weekly_rate = contract.weekly_rate1
      contract.weekly_parent_fee = contract.weekly_parent_fee_1(contract.start_date)
      contract.weekly_subsidy = contract.weekly_subsidy1(contract.start_date)
      contract.save
    end
  end
end
