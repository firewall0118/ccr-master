require 'spec_helper'

describe Child do
  it "calculates the age of the child correctly" do
    @date_3years_ago = Date.today + 40.days  - 4.years
    @child = create(:child, date_of_birth: @date_3years_ago  )
    expect(@child.current_age).to eq(3)
  end

  it '#age_group' do
    expect(Child.new(date_of_birth: 0.years.ago).age_group.name).to eq('Infants')
    expect(Child.new(date_of_birth: 1.years.ago).age_group.name).to eq('Infants')
    expect(Child.new(date_of_birth: 2.years.ago).age_group.name).to eq('Toddlers')
    expect(Child.new(date_of_birth: 3.years.ago).age_group.name).to eq('Toddlers')
    expect(Child.new(date_of_birth: 4.years.ago).age_group.name).to eq('Preschool')
    expect(Child.new(date_of_birth: 5.years.ago).age_group.name).to eq('Preschool')
    expect(Child.new(date_of_birth: 6.years.ago).age_group.name).to eq('Preschool')
    expect(Child.new(date_of_birth: 7.years.ago).age_group.name).to eq('School Age')
  end
end
