require 'spec_helper'

describe ProviderRate do
  
  context "#validation" do
    
    describe "with valid values" do 
      let(:one_week_ago) { 1.weeks.ago  }
      let(:three_weeks_from_now) { 3.weeks.from_now }
      let(:provider_rate) do
        create(:provider_rate,:part_time_toddler_weekly_rate_cents => 1001, 
               :effective_date => one_week_ago , 
               :end_date => three_weeks_from_now)
      end
    

      it "is a valid factory" do
        expect(provider_rate.valid?).to be(true)
        expect(provider_rate.part_time_toddler_weekly_rate_cents).to be(1001)
        expect(provider_rate.end_date.to_date).to eq(three_weeks_from_now.to_date)
      end 

      it "validates the correct combination of discount options" do
        # if has sibling discounts 
        
        # percentage is between 1 - 100 if not nil
        # only either percentance or fixed is entered , part time 
        # only either percentance or fixed is entered , full time 
      end 
   

      it { should validate_numericality_of(:full_time_sibling_discount_percentage) }
      it { should validate_numericality_of(:part_time_sibling_discount_percentage) }
 
    end 

    describe "when using invalid dates " do   
      let(:one_week_ago) { 1.weeks.ago  }
      let(:three_weeks_from_now) { 3.weeks.from_now }
      let(:provider_rate) do
       build(:provider_rate,:part_time_toddler_weekly_rate_cents => 1001, 
              :effective_date =>  three_weeks_from_now,
              :end_date => one_week_ago )
      end 

      it "is not valid" do
        expect(provider_rate.valid?).to be(false)
        expect(provider_rate.end_date.to_date).to eq(one_week_ago.to_date)
      end 
    end
  
  end 
end

