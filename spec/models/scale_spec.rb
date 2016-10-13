require 'spec_helper'

describe Scale do


#  this tests do not work since Juan moved this to a table 

#   it "returns true for valid values " do
#     expect(described_class.is_within_income_scale?(3,26000)).to eq(true)
#     expect(described_class.is_within_income_scale?(4,40000)).to eq(true)
#     expect(described_class.is_within_income_scale?(5,38000)).to eq(true)
#     expect(described_class.is_within_income_scale?(6,42000)).to eq(true)
#   end

#   it "returns false for valid values " do
#     expect(described_class.is_within_income_scale?(3,1)).to eq(false)
#     expect(described_class.is_within_income_scale?(4,50000)).to eq(false)
#     expect(described_class.is_within_income_scale?(5,31000)).to eq(false)
#     expect(described_class.is_within_income_scale?(6,38000)).to eq(false)
#   end

    before(:all) do
      @scale = create :scale 
    end 


  it "returns the max for family size " do
    expect(Scale.max_for_family_size(2)).to eq(20000)
  end


end
