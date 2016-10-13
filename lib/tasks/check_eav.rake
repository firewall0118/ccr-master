namespace :contracts do
  desc 'Recalculate the contract fees'
  task check_eav: :environment do
    sql = %q(
      TO_DATE(CONCAT(provider_attendances.year, LPAD(''||provider_attendances.month, 2, '0')), 'YYYYMM') 
      BETWEEN date_trunc('month', contracts.start_date) AND contracts.end_date
    )
    invalid_contracts = Contract.joins(:provider_attendances).where.not(sql).distinct(:id)
    CSV.open("eav_status.csv", "wb") do |csv|
      csv << ['ID', 'Child', 'Parent', 'Start Date', 'End Date', 'Expected EAVs', 'Got EAVs', 'Created At']
      invalid_contracts.each do |contract|
        months = (contract.end_date.year * 12 + contract.end_date.month) - (contract.start_date.year * 12 + contract.start_date.month)
        csv << [
          contract.id, 
          contract.child.full_name, 
          contract.family.name, 
          contract.start_date,
          contract.end_date,
          contract.provider_attendances.pluck(:month).sort,
          contract.created_at.to_date
        ]
      end
    end
  end

  task correct_eav: :environment do
    @contracts = Contract.all
    @contracts.each do |contract|
      date = contract.start_date.beginning_of_month
      invalid_eavs = contract.provider_attendances.where.not("TO_DATE(CONCAT(year, LPAD(''||month, 2, '0')), 'YYYYMM') BETWEEN ? AND ?", date, contract.end_date)
      invalid_eavs.destroy_all
      while date < contract.end_date
        attendance = contract.provider_attendances.find_by({month: date.month, year: date.year})
        contract.provider_attendances.create({
          provider: contract.provider,
          year: date.year,
          month: date.month
        }) unless attendance
        date += 1.month
      end
    end
  end
end
