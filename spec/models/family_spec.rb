require 'spec_helper'

describe Family do

  context "validation" do

      it { should validate_presence_of(:first_parent_name) }
      it { should validate_presence_of(:first_parent_last_name) }
      it { should validate_presence_of(:first_parent_race) }
      it { should validate_presence_of(:first_parent_sex) }
      it { should validate_presence_of(:first_parent_date_of_birth) }
      it { should validate_presence_of(:first_parent_residence_county_id) }

      it { should validate_numericality_of(:first_parent_first_job_annual_income).is_greater_than(0).is_less_than(500000) }
      it { should validate_numericality_of(:first_parent_second_job_annual_income).is_greater_than(0).is_less_than(500000) }
      it { should validate_numericality_of(:first_parent_third_job_annual_income).is_greater_than(0).is_less_than(500000) }
      it { should validate_numericality_of(:second_parent_first_job_annual_income).is_greater_than(0).is_less_than(500000) }
      it { should validate_numericality_of(:second_parent_second_job_annual_income).is_greater_than(0).is_less_than(500000) }
      it { should validate_numericality_of(:second_parent_third_job_annual_income).is_greater_than(0).is_less_than(500000) }

  end

  it "calculates first parent total hours correctly " do

      family = Family.new({ :first_parent_first_job_average_hours_worked => nil,
                             :first_parent_second_job_average_hours_worked => 23,
                             :first_parent_third_job_average_hours_worked => 4
                            })
      expect(family.first_parent_total_work_hours).to eq(27)

  end

  it "calculates first parent total annual income correctly " do

    family = Family.new({ :first_parent_first_job_annual_income => 12987.01,
                             :first_parent_second_job_annual_income => 23000,
                             :first_parent_third_job_annual_income => nil
                            })
    expect(family.first_parent_total_annual_income).to eq(35987.01)

  end


  it "calculates second parent total hours correctly " do

      family = Family.new({ :second_parent_first_job_average_hours_worked => nil,
                             :second_parent_second_job_average_hours_worked => 9,
                             :second_parent_third_job_average_hours_worked => 6
                            })
      expect(family.second_parent_total_work_hours).to eq(15)

  end

  it "calculates second parent total annual income correctly " do

    family = Family.new({ :second_parent_first_job_annual_income => 12987.91,
                           :second_parent_second_job_annual_income => 10000.09,
                             :second_parent_third_job_annual_income => nil
                            })
    family.save
    expect(family.second_parent_total_annual_income).to eq(22988)

  end

  it "calculates total annual income correctly " do

    family = Family.new({  :first_parent_first_job_annual_income => 12987.01,
                            :first_parent_second_job_annual_income => 20000,
                            :first_parent_third_job_annual_income => nil,
                            :second_parent_first_job_annual_income => 30000,
                            :second_parent_second_job_annual_income => 10000,
                            :second_parent_third_job_annual_income => nil
                            })
    family.save
    expect(family.second_parent_second_job_annual_income.class).to eq(BigDecimal)
    expect(family.second_parent_first_job_annual_income).to eq(30000)
    expect(family.second_parent_second_job_annual_income).to eq(10000)
    expect(family.second_parent_third_job_annual_income).to eq(nil)
    expect(family.total_income.to_s).to eq("72987.01")

  end

  describe '#total_income, #size, and #is_within_income_scale?' do

    let(:family) do
      create(:family,
        first_parent_first_job_employer_name:         'qwe',
        first_parent_first_job_average_hours_worked:  35,
        first_parent_first_job_annual_income:         22222.22,
        first_parent_first_job_hourly_rate:           11.11,
        children: 3.times.map{ build(:child) }
        )
    end

    it 'children association works' do
      family.children.size.should == 3
    end

    it 'test DB is in transaction mode' do
      Family.all.size.should == 0
      Child.all.size.should == 0
    end

    it '#total_income' do
      family.total_income.should == 22222.22
    end

    it '#is_within_income_scale?' do
      family.is_within_income_scale?.should == false
    end

    it '#is_within_income_scale? changes when parent earns more' do
      family.update_attribute :first_parent_first_job_annual_income, 44444
      family.reload

      family.first_parent_first_job_annual_income.should == 44444
      family.scale.should_not be_nil
      family.is_within_income_scale?.should == true
    end

    it '#size' do
      family.size.should == 5
      family.children << create(:child)
      family.size.should == 6
    end

    # Different ways to alter counter cache
    it '#children_count' do
      family.reload
      family.children.size.should == 3
      family.children_count.should == 3
      create(:child, family: family)
      family.reload
      family.children_count.should == 4

      family.children.last.destroy
      family.reload
      family.children_count.should == 3

      family.children.create attributes_for(:child)
      family.reload
      family.children_count.should == 4

      # This one does not alter counter cache
      family.children << create(:child)
      family.save
      family.reload
      family.children_count.should == 4
    end

    it '#scale' do
      # Because income is too low for 3 children
      family.scale.should == nil

      family.update_attribute :first_parent_first_job_annual_income, 44444
      family.reload

      family.scale.should == Scale.find_by(family_size: 5)
    end

    it 'has a hook updating annual_income' do
      family.annual_income.should == family.total_income
      family.update_attribute :first_parent_first_job_annual_income, 55555
      family.annual_income.should == 55555
      family.reload
      family.annual_income.should == 55555
    end
  end

end
