require 'spec_helper'

describe Contract do
  subject { create :contract }

  before(:all) do
    create :scale
  end

  it 'factory works' do
    should be_persisted
  end

  it "should calculate rates correctly" do
    # A provider, Myra’s Child Care Center charges $105.00 per week for a preschool child.
    #
    @provider = Provider.new({
            :name => "Myra’s Child Care Center",
            :director_name => "Myra",
            :physical_address_street => "abc",
            :physical_address_city => "abc",
            :physical_address_state => "abc",
            :physical_address_zip => "abc",
            :phone_number => "021",
            :provider_type_id => 1,
            :county_id => 1,
            :provider_license_type => 1,
            :current_rate_attributes => {
              :full_time_toddler_weekly_rate_cents => 10500,
              :full_time_preschool_weekly_rate_cents => 10500,
              :full_time_infant_weekly_rate_cents => 10500,
              :full_time_school_weekly_rate_cents => 10500,
              :part_time_toddler_weekly_rate_cents => 4500,
              :part_time_preschool_weekly_rate_cents => 4500,
              :part_time_infant_weekly_rate_cents => 4500,
              :part_time_school_weekly_rate_cents => 4500,
              :effective_date => 1.days.ago
        }
    })

    expect(@provider.current_rate.full_time_preschool_weekly_rate_cents).to eq(10500)

    # expect(Scale.max_for_family_size(2)).to eq(20000)

    # A parent, Mrs. Allison’s has a son and her parent fee is 82%. (Her annual income
    # divided by the maximum for the family size 2 according to our scale).
    family = Family.new({   :first_parent_name => "Mrs Alison",
                            :first_parent_first_job_average_hours_worked => 40,
                            :first_parent_first_job_annual_income => 16400
    })
    family.children << create(:child, date_of_birth: Date.today - 4  )

    expect(family.first_parent_first_job_annual_income).to eq(16400)
    expect(family.size).to eq(2)
    # expect(Scale.max_for_family_size(2)).to eq(20000)
    # expect(Scale.max_for_family_size(family.size)).to eq(20000)
    # expect(family.parent_fee_percent(19999)).to eq(82)

    #     expect(@contract.daily_rate).to eq(21)



  end

  it '::overlaps' do
    contract = create(:contract, start_date: Date.today, end_date: 5.days.from_now)
    expect do
      create(:contract, start_date: 1.days.from_now, end_date: 5.days.from_now)
    end.to raise_error
    expect do
      create(:contract, start_date: 5.days.ago, end_date: 6.days.from_now)
    end.to raise_error
    create(:contract, start_date: 5.days.ago, end_date: 3.days.ago, child_id: 1)
    Contract.all.size.should == 2
    Contract.overlaps(contract).size.should == 0
  end

  it '#rejected?' do
    contract = create(:contract, rejection_reasons: ['over_income'])
    contract.over_income.should be_true
    contract.should be_rejected
  end

  context 'given many contacts' do
    let(:child){ create(:child) }
    def contract(start_date, end_date)
      create(:contract, child: child, start_date: start_date,
        end_date: end_date)
    end
    before do
      contract 4.days.ago, 1.days.ago
      contract 0.days.ago, 2.days.from_now
      contract 3.days.from_now, 5.days.from_now
    end

    it '#current?' do
      Contract.all.size.should == 3
      child.contracts.size.should == 3
      child.contracts.current.size.should == 1
      child.contracts.current.first.start_date.should == 0.days.ago.to_date
      child.contracts.current.first.end_date.should == 2.days.from_now.to_date
      child.contracts.current.first.should be_current
    end
  end
end
