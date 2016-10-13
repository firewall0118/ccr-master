class SettingSerializer < ActiveModel::Serializer
  attributes :id, :alabama_minimum_wage, :minimum_work_hours, :fiscal_year_start, :fiscal_year_end

  def fiscal_year_start
    object.fiscal_year_start.to_s
  end

  def fiscal_year_end
    object.fiscal_year_end.to_s
  end
end
