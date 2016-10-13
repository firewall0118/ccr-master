module ReportsHelper
  def family_dates(start_date, end_date, family)
    dates = PaperTrail::Version.where(item: family.parents).pluck(:created_at).compact
    dates.push(family.created_at)
    dates.push(end_date)
    dates.sort
  end
end
