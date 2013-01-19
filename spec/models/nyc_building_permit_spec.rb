require 'spec_helper'

describe NycBuildingPermit do
  before :all do
  	NycBuildingPermit.nyc_opendata_load(ENV['NYC_OPEN_DATA_PERMITS'],10)
  end

  it 'updates NycBuildingPermits' do
  	NycBuildingPermit.count.should > 0
  end

  it 'updates PropertyOwners' do
  	PropertyOwner.count.should > 0
  end

  it 'updates LicensedContractors' do
  	LicensedContractor.count.should > 0
  end

  xit 'updates PropertyBuildings' do
  	PropertyBuilding.count.should > 0
  end

  xit 'updates Permits' do
  	Permit.count.should > 0
  end

  after :all do
  	NycBuildingPermit.delete_all
  	PropertyOwner.delete_all
  	LicensedContractor.delete_all
  	# PropertyBuilding.delete_all
  	# Permit.delete_all
  end
end
