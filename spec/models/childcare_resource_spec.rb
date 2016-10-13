require 'spec_helper'

describe ChildcareResource do
  it { should validate_presence_of   :name }
  it { should validate_uniqueness_of :name }

  it '::get' do
    described_class.get(:company_name).should == 'Childcare Resources'
    described_class.get(:non_existent).should be_nil
  end

  it '::method_missing' do
    described_class.company_name.should == 'Childcare Resources'
  end

  it '::split' do
    described_class.split('child_search_fields').should ==
      described_class.get('child_search_fields').split(',')
  end

  it '::element_name' do
    described_class.element_name(Child).should == 'child'
    described_class.element_name(Child.new).should == 'child'
  end

  it '::search_fields_for' do
    described_class.search_fields_for(Child).should ==
      described_class.get('child_search_fields').split(',')

    expect{ described_class.search_fields_for(FundingCycle) }
      .to raise_error
  end

  it '::search_fields_for' do
    described_class.result_fields_for(Child).should ==
      described_class.get('child_result_fields').split(',')

    expect{ described_class.search_fields_for(FundingCycle) }
      .to raise_error
  end
end
