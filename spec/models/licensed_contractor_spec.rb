require 'spec_helper'

describe LicensedContractor do
  it 'should have bin defined' do
  	subject.attribute_names.include?('bin').should eq(true)
  end
end
