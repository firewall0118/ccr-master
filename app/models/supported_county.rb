class SupportedCounty < ActiveRecord::Base

  belongs_to :funder
  belongs_to :county

  accepts_nested_attributes_for :county 

end
