3.times { FactoryGirl.create :family,
  first_parent_first_job_annual_income: 33333 }
Family.all.each do |family|
  (rand(4) + 1).times.map { FactoryGirl.create :child, family: family }
end
# Parent fee
Family.all.each &:save

3.times do
  random_counties = County.all.sample(rand(County.all.size) + 1)
  FactoryGirl.create :funder, counties: random_counties
end

3.times { FactoryGirl.create :provider }

# Funding cycle for each funder
Funder.all.each do |funder|
  FactoryGirl.create :funding_cycle, funder: funder
end

puts 'Added sample data!'
