class SearchesController < ApplicationController

  def index
    @search = params[:search]
    @search ||= {}
  end

  def create
    
    msg = nil

    if !params['block'].blank?
      if params['borough'].blank?
        msg = "'Block' requires 'Borough' to be entered"
      end
    end
    if !params['lot'].blank?
      if params['borough'].blank? || params['block'].blank?
        msg = "'Lot' requires both 'Borough' and 'Block' to be entered"
      end
    end

    if msg.blank?
      msg = PropertyBuilding.borough_check(
        params['borough'], params['zipcode'], params['community_district'])
    end
    if msg.present?
      flash[:error] = msg
      redirect_to searches_url
    else
      search = params.reject{|key,value| value == "" || value == "action" || value == "controller" } 
      session[:search] = search
      redirect_to searches_contractors_url
    end
  end

  def contractors_post (search = {})

    case search[:sort_by]
      when "Licensee"     then permits_order =
        "full_name, license_type, max(recent_filing_date) DESC"
      when "License-Type"  then permits_order =
        "license_type, business_name, full_name, max(recent_filing_date) DESC"
      when "Business-Name" then permits_order =
        "business_name, license_type, full_name, max(recent_filing_date) DESC"
    #  when "Permit-Count"  then permits = permits.where(?:value)
      else
        permits_order = ''
    end
    
    search_message = 'Given Search Parameter(s): '
    search.delete('utf8')
    search.delete('authenticity_token')
    search.delete(:action)
    search.delete(:controller)
    search.each {|key, value| search_message << "#{key}:'#{value}'; "}

    contractor_parameters = {}
    contractor_parameters[:search_message] = search_message

    contractors = Permit.search_for_contractors(search)
    contractors = contractors.select("full_name").select("business_name").select("phone").select("license_type").select("license_number")  
    contractors = contractors.select("max(permit_issuance_date) as freshness_date")
    contractors = contractors.group("full_name").group("business_name").group("phone").group("license_type").group("license_number")
    contractors = contractors.order(permits_order) if permits_order.present?
    contractor_parameters[:search_relation] = contractors
    contractor_parameters
  end

  def contractors #get

    permits = contractors_post(session['search'])
    @permits = {}
    @permits[:search_message]= permits[:search_message]
    @permits[:permittees] =  permits[:search_relation].paginate(:page => params[:page], :per_page => 10)
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
