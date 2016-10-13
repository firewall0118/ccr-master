class ChildrenSerializer < ActiveModel::Serializer
  attributes :id, :current_age, :gender, :relationship, :age_group,
             :full_name, :first_name, :last_name,
             :date_of_birth, :race

  has_one :current_contract

  def age_group
    @object.age_group.try(:name)
  end
end
