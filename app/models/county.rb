class County < ActiveRecord::Base
  has_many :providers
  has_many :county_rates

  has_many :supported_counties
  has_many :funders, :through => :supported_counties


  def average_infant_weekly_cost(provider_type_name)
    age_group = AgeGroup.where(name: 'Infant').first
    provider_type = ProviderType.where(name: provider_type_name).first
    provider_rates = setting_provider_rates.where(age_group_id: age_group.id).where(provider_type_id: provider_type.id)

    if provider_rates.size > 0
      provider_rates.first
    else
      nil
    end
  end

  def average_toddler_weekly_cost(provider_type_name)
    age_group = AgeGroup.where(name: 'Toddler').first
    provider_type = ProviderType.where(name: provider_type_name).first
    provider_rates = setting_provider_rates.where(age_group_id: age_group.id).where(provider_type_id: provider_type.id)

    if provider_rates.size > 0
      provider_rates.first
    else
      nil
    end
  end

  def average_preschool_weekly_cost(provider_type_name)
    age_group = AgeGroup.where(name: 'Preschool').first
    provider_type = ProviderType.where(name: provider_type_name).first
    provider_rates = setting_provider_rates.where(age_group_id: age_group.id).where(provider_type_id: provider_type.id)

    if provider_rates.size > 0
      provider_rates.first
    else
      nil
    end
  end

  def average_school_age_weekly_cost(provider_type_name)
    age_group = AgeGroup.where(name: 'School').first
    provider_type = ProviderType.where(name: provider_type_name).first
    provider_rates = setting_provider_rates.where(age_group_id: age_group.id).where(provider_type_id: provider_type.id)

    if provider_rates.size > 0
      provider_rates.first
    else
      nil
    end
  end
end
