module ApplicationHelper

  def decorate(record_or_assoc)
    ActiveDecorator::Decorator.instance.decorate record_or_assoc
  end

  def family_income_history(family)
    versions = PaperTrail::Version.where(item: family.parents)
    dates = []
    incomes = []

    dates.push([family.created_at, family.created_at])
    versions = versions.where.not(active_at: nil).order(:created_at)
    dates = dates + versions.pluck(:created_at, :active_at)

    versions.each do |version|
      parent = version.reify
      incomes.push parent.sum_of_incomes
    end

    incomes.push family.annual_income
    [dates, incomes]
  end
end
