require 'spec_helper'

describe Funder do

  context "validation" do

   it { should validate_presence_of(:name) }
   it { should validate_presence_of(:address) }
   it { should validate_presence_of(:phone_number) }
   it { should validate_presence_of(:contact_person) }
   it { should validate_presence_of(:email) }


  end

  it '#children_funded' do
    Contract.create(child_id: 1)
    Contract.create(child_id: 2)
    Contract.create(child_id: 2)
    Contract.create(child_id: 3)
    Contract.create(child_id: 3)
    Contract.create(child_id: 3)

    {
      Contract.all                     => 3,
      Contract.where(child_id: 3)      => 1,
      Contract.where(child_id: [2, 3]) => 2
    }.each do |contracts, children_funded|

      funder = create(:funder)
      cycle  = create(:funding_cycle, contracts: contracts, funder: funder)
      funder.children_funded.should == children_funded

    end
  end

end
