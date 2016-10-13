class ContractSerializer < ActiveModel::Serializer
  attributes :id, :days_attended, :weekly_rate, :weekly_parent_fee, :discount,
             :weekly_subsidy, :status, :state, :start_date, :end_date,
             :child, :is_full_time, :care_provided,
             :rate_source, :funding_cycle_id, :provider_id

  has_one :provider
  has_one :funder
  has_one :family
  has_one :child, serializer: ChildSerializer

  def care_provided
    @object.is_full_time ? "FT" : "PT"
  end

  def start_date
    @object.start_date.to_s
  end

  def end_date
    @object.end_date.to_s
  end

  def rate_source
    " / #{@object.rate_source}"
  end

  def is_full_time
    object.is_full_time? ? 'true' : 'false'
  end
end
