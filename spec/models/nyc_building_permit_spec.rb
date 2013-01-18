require 'spec_helper'

describe NycBuildingPermit do
  before :all do
  	NycBuildingPermit.nyc_opendata_load(ENV['NYC_OPEN_DATA_PERMITS'],10)
  end

  it 'are updating NycBuildingPermits' do
  	NycBuildingPermit.count.should > 0
  end

  xit 'are updating PropertyOwners' do
  	PropertyOwner.count.should_not be(0)
  end

  xit 'are updating LicensedContractors' do
  	LicensedContractor.count.should_not be(0)
  end

  xit 'are updating PropertyBuildings' do
  	PropertyBuilding.count.should_not be(0)
  end

  xit 'are updating Permits' do
  	Permit.count.should_not be(0)
  end

  after :all do
  	NycBuildingPermit.delete_all
  	# PropertyOwner.delete_all
  	# LicensedContractor.delete_all
  	# PropertyBuilding.delete_all
  	# Permit.delete_all
  end
end
