class Scale < ActiveRecord::Base
  has_many :families

  validates_numericality_of :maximum_income, :greater_than => :minimum_income

  def self.is_within_income_scale?(family_size,income)
    income_bracket = Scale.find_by(family_size: family_size)
    income_more_than_minium = income_bracket.minimum_income <= income
    income_less_than_maximum = income <= income_bracket.maximum_income
    income_more_than_minium && income_less_than_maximum
  end

  def self.matched_scale(size, annual_income)
    Scale.find_by('family_size = ? AND ? BETWEEN minimum_income AND maximum_income', size, annual_income)
  end

  def self.max_for_family_size(family_size)
    family_size = 2 if family_size < 2

    scale = Scale.find_by(family_size: family_size)
    scale.maximum_income
  end
end
