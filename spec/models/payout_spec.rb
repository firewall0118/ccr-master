require 'spec_helper'

describe Payout do
  it 'set partial amounts' do
    contract = create(:contract, weekly_parent_fee: 80, weekly_subsidy: 20)
    payout = create(:payout, contract: contract)
    contract.weekly_rate.should == 100
    payout.amount_cents.should  == 10000
    payout.parent_amount.should == BigDecimal(80)
    payout.funder_amount.should == BigDecimal(20)
  end
end
