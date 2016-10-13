namespace :payouts do
  desc 'load sample data'
  task close_month: :environment do
    Payout.includes(:provider_attendance).all.each do |payout|
      payout.provider_attendance.update_attribute(:closed, true)
    end
  end
end
