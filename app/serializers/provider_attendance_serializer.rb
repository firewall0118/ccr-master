class ProviderAttendanceSerializer < ActiveModel::Serializer
  attributes :id, :year, :month, :days, :closed

  has_one :contract
end
