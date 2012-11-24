class SearchesController < ApplicationController
  def index
    # define @search_parameters

  end

  def contractors #post
    temp1 = params.reject{|key,value| value == ""}
    @permits = {}
    @permits[:search] = temp1
    @permits[:permittees] = Array.new
    8.times do |count|
      permittee = {}
      permittee[:permittee_first_and_last_name] = 
        "#{Faker::Name.last_name}, #{Faker::Name.first_name}"
      permittee[:permittee_business_name] = Faker::Company.name
      permittee[:permittee_phone_number] = Faker::PhoneNumber.phone_number
      license_type = params[:license_type].blank? ? 'Electric Contractor' : params[:license_type]
      permittee[:permittee_license_kind] =  license_type
      permittee[:permittee_license_integer] = '01234567890'
      permittee[:job_start_date] = '09/01/2006'
      permittee[:expiration_date] = '10/30/2011'
      permittee[:permit_count] = ((count % 3) + 1).to_s
      @permits[:permittees] << permittee  
    end
    # flash[:notice] = "[**Start**]\n#{@permits.inspect}\n[**End**]"
    # get @search_parameters
  end

  def owners #post
    temp1 = params.reject{|key,value| value == ""}
    @permits = {}
    @permits[:search] = temp1
    @permits[:permittees] = Array.new
    8.times do |count|
      permittee = {}
      permittee[:owner_full_name] = 
        "#{Faker::Name.last_name}, #{Faker::Name.first_name}"
      permittee[:owner_business_type] = 
        ((count % 3) != 0)? "Proprietorship" : 'Corporation'
      permittee[:owner_business_name] = "#{Faker::Company.name} #{Faker::Company.suffix}"
      permittee[:owner_phone_number] = Faker::PhoneNumber.phone_number
      permittee[:owner_street_address] =  
        "#{Faker::Address.building_number} #{Faker::Address.street_name} #{Faker::Address.street_suffix}"
      permittee[:owner_city_state_zip] = 
        "#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
      permittee[:job_start_date] = '09/01/2006'
      permittee[:expiration_date] = '10/30/2011'
      permittee[:permit_count] = ((count % 3) + 1).to_s
      @permits[:permittees] << permittee  
    end
    # flash[:notice] = "[**Start**]\n#{@permits.inspect}\n[**End**]"
  end

  def agents #post
    temp1 = params.reject{|key,value| value == ""}
    @agents = {}
    @agents[:search] = temp1
    @agents[:licensees] = Array.new
    8.times do |count|
      licensee = {}
      licensee[:licensee_full_name] = 
        "#{Faker::Name.last_name}, #{Faker::Name.first_name}"
      licensee[:licensee_license_kind] = ((count % 3) != 0)? 'Real Estate Brokerage' : 'Law Firm'
      licensee[:licensee_business_name] = "#{Faker::Company.name} #{Faker::Company.suffix}"
      licensee[:licensee_phone_number] = Faker::PhoneNumber.phone_number
      licensee[:licensee_street_address] =  
        "#{Faker::Address.building_number} #{Faker::Address.street_name} #{Faker::Address.street_suffix}"
      licensee[:licensee_city_state_zip] = 
        "#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
      licensee[:licensee_expiration_date] = '10/30/2014'
      @agents[:licensees] << licensee  
    end
    # flash[:notice] = "[**Start**]\n#{@agents.inspect}\n[**End**]"
  end

  def suppliers #post
    temp1 = params.reject{|key,value| value == ""}
    @suppliers = {}
    @suppliers[:search] = temp1
    @suppliers[:suppliers] = Array.new
    8.times do |count|
      supplier = {}
      supplier[:supplier_full_name] = 
        "#{Faker::Name.last_name}, #{Faker::Name.first_name}"
      supplier[:supplier_kind] = ((count % 3) != 0)? 'Hardware Store' : 'Lock Smith'
      supplier[:supplier_business_name] = "#{Faker::Company.name} #{Faker::Company.suffix}"
      supplier[:supplier_phone_number] = Faker::PhoneNumber.phone_number
      supplier[:supplier_street_address] =  
        "#{Faker::Address.building_number} #{Faker::Address.street_name} #{Faker::Address.street_suffix}"
      supplier[:supplier_city_state] = 
        "#{Faker::Address.city}, #{Faker::Address.state_abbr}"
      supplier[:supplier_zip] = "#{Faker::Address.zip_code}"
      supplier[:supplier_expiration_date] = '10/30/2014'
      @suppliers[:suppliers] << supplier  
    end
    # flash[:notice] = "[**Start**]\n#{@suppliers.inspect}\n[**End**]"
  end
end
