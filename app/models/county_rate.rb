class CountyRate < ActiveRecord::Base
  belongs_to :provider_type
  belongs_to :county
  validates :provider_type,
            :county, presence: true

  validates :part_time_toddler_weekly_rate,
            :part_time_infant_weekly_rate,
            :part_time_school_weekly_rate,
            :part_time_preschool_weekly_rate,
            :full_time_toddler_weekly_rate,
            :full_time_infant_weekly_rate,
            :full_time_school_weekly_rate,
            :full_time_preschool_weekly_rate,
            presence: true
end
