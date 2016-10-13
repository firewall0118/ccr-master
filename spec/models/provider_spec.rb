require 'spec_helper'

describe Provider do



  # let(:rates_methods){ Provider.rates_methods}

  subject{ create :provider }
  let!(:contracts){ 3.times.map{create :contract, child: create(:child),
    provider: subject} }

  # it 'factory sets all 5 rates' do
  #   provider.rates.size.should == rates_methods.size
  #   provider.rates.each do |rate|
  #     rate.should be_a BigDecimal
  #   end
  # end

  # it 'has a hook to update min and max rates' do
  #   provider.update_attribute provider.rates_methods.first, 11
  #   provider.update_attribute provider.rates_methods.last, 111
  #   provider.min_rate.should == 11
  #   provider.max_rate.should == 111
  #   provider.reload
  #   provider.min_rate.should == 11
  #   provider.max_rate.should == 111
  # end

  context "nested attributes " do

    describe "Update current rates" do
      it "is valid " do

        @provider = Provider.new({
            :name => "name2222",
            :director_name => "dn",
            :physical_address_street => "abc",
            :physical_address_city => "abc",
            :physical_address_state => "abc",
            :physical_address_zip => "abc",
            :phone_number => "021",
            :provider_type_id => 1,
            :county_id => 1,
            :provider_license_type => 1,
            :current_rate_attributes => {
              :part_time_toddler_weekly_rate_cents => 1200,
              :full_time_toddler_weekly_rate_cents => 1200,
              :part_time_school_weekly_rate_cents => 1200,
              :effective_date => 1.days.ago

            }
        })
        expect(@provider.save).to eq(true)
        expect(@provider.valid?).to eq(true)
        puts @provider.current_rate.inspect
        expect(@provider.current_rate.full_time_toddler_weekly_rate_cents).to eq(1200)
      end
    end

  end

  it 'children_count column is updated when contract is saved' do
    subject.reload
    expect(subject.contracts.size).to equal(3)
    expect(subject.children_count).to equal(3)
    create(:contract, child: create(:child), provider: subject)
    subject.reload
    expect(subject.children_count).to equal(4)
  end
end
