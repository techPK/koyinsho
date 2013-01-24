require 'spec_helper'

describe PropertyBuilding do
  it 'should have bin defined' do
  	subject.attribute_names.include?('bin').should eq(true)
  end
  it 'should have recent_filing_date defined' do
  	subject.attribute_names.include?('recent_filing_date').should eq(true)
  end
end
