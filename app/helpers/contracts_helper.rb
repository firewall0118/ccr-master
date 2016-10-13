module ContractsHelper
  def funder_options(funder=nil)
    if funder
      funders = Funder.where(id: funder.id)
    else
      funders = Funder.all
    end
    funders.includes(:funding_cycles).map do |f|
      [
        f.name,
        f.funding_cycles.map do |c|
          [
            "#{c.start_date} to #{c.end_date} " +
            "- #{number_to_currency c.amount}",
            c.id
          ]
        end
      ]
    end
  end

  def family_statuses
    statuses = [
      ['Select All', 'all'],
      ['Application in Process', 'in_process'],
      ['Accepted', 'accepted'],
      ['Denied', 'denied']
    ]
  end

  def redetermination_periods(family)
    family.redetermination_periods.each_with_index.map { |p, i| ["#{p[0].to_date} ~ #{(p[1]-1.day).to_date}", i] }
  end
end
