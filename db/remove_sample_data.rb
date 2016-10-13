[Family, Child, Funder, FundingCycle, Provider, Contract].each do |model|
  model.destroy_all
end
puts 'Remove sample data!'
