namespace :db do
  desc 'load sample data'
  task sample_data: :environment do
    load Rails.root.join 'db', 'sample_data.rb'
  end

  desc 'remove sample data'
  task remove_sample_data: :environment do
    load Rails.root.join 'db', 'remove_sample_data.rb'
  end

  desc 'drop, create, migrate'
  task bootstrap: [:drop, :create, :migrate]

  desc 'seed, sample data'
  task seed_sample: [:seed, :remove_sample_data, :sample_data]
end
