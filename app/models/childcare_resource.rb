class ChildcareResource < ActiveRecord::Base

  RACES = ['White', 'Black', 'A. Indian', 'Asian', 'Hawaiian N.', 'Hispanic', 'Other']
  GENDERS = ['Male','Female']
  MARITAL_STATUSES = ['Single', 'Married', 'Separated', 'Divorced', 'Widowed']

  validates :name, presence: true, uniqueness: true

  def self.get(name)
    find_by(name: name).try(:value)
  end

  def self.method_missing(method, *args, &block)
    get(method) || super
  end

  def self.split(name, sign = ',')
    get(name).try(:split, sign) || []
  end

  # element_name(Child) => 'child'
  # element_name(Child.new) => 'child'
  def self.element_name(model_or_class)
    klass = model_or_class.is_a?(Class) ? model_or_class : model_or_class.class
    klass.name.downcase
  end

  # Example:
  # if child_search_fields = 'qwe,asd'
  # then search_fields_for(Child) == ['qwe', 'asd']
  # and  search_fields_for(Child.first) == ['qwe', 'asd']
  def self.search_fields_for(model_or_class)
    split("#{element_name(model_or_class)}_search_fields").presence ||
      raise("Please set #{element_name(model_or_class)}_search_fields in /childcare_resources.")
  end

  def self.result_fields_for(model_or_class)
    split("#{element_name(model_or_class)}_result_fields").presence ||
      raise("Please set #{element_name(model_or_class)}_result_fields in /childcare_resources.")
  end
end
