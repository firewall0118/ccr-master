require 'spec_helper'

describe FundingCycle do

  context "validation" do
    it { should validate_numericality_of(:amount).only_integer }
    it { should allow_value(Date.new).for(:start_date) }
    it { should_not allow_value("a string").for(:start_date) }


    it "Start date must be before end date" do
      one_week_ago = Time.now - 7.days
      in_one_week = Time.now + 7
      @cycle = FundingCycle.new({:amount => 2, :start_date => in_one_week, :end_date => one_week_ago })
      expect(@cycle.valid?).to be(false)
    end

    it "is valid with valid attributes" do
      one_week_ago = Time.now - 7.days
      in_one_week = Time.now + 7
      @cycle = FundingCycle.new({:amount => 2, :start_date => one_week_ago, :end_date => in_one_week })
      expect(@cycle.valid?).to be(true)
    end

  end

  let(:funding_cycle) do
    create :funding_cycle
  end

  it 'sets start and end date' do
    funding_cycle.start_date.should be_a Date
    funding_cycle.end_date.should be_a Date
    funding_cycle.end_date.should > funding_cycle.start_date
  end

end
