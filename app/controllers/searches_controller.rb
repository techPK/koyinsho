class SearchesController < ApplicationController
  def index
    @search = params[:search]
    # define @search
    # @search = {} unless params(:search)
    flash[:notice] = "[**Start**]\n#{params.inspect}\n[**End**]"

  end

  def contractors #post
    if params['search'].nil?
      flash[:error] = 'Please specify search parameters'
      redirect_to search_url
    else
      @search = params['search'].reject{|key,value| value == "" || value == "action" || value == "controller" }
      msg = nil

      if !@search['block'].blank?
        if @search['borough'].blank?
          msg = "'Block' requires 'Borough' to be entered"
        end
      end
      if !@search['lot'].blank?
        if @search['borough'].blank? || params['block'].blank?
          msg = "'Lot' requires both 'Borough' and 'Block' to be entered"
        end
      end

      if msg.blank?
        msg = Permit.borough_check(
          @search['borough'], @search['zipcode'], @search['community_district'])
      end
      if msg.present?
        flash[:error] = msg
        redirect_to searches_url
      else
        case @search['sort_by']
          when "Licensee"     then permits_order =
            "licensee_full_name, licensee_license_kind, max(permit_expiration_date) DESC"
          when "License-Type"  then permits_order =
            "licensee_license_kind, licensee_business_name, licensee_full_name, max(permit_expiration_date) DESC"
          when "Business-Name" then permits_order =
            "licensee_business_name, licensee_license_kind, licensee_full_name, max(permit_expiration_date) DESC"
        #  when "Permit-Count"  then permits = permits.where(?:value)
          else
            permits_order = ''
        end
        
        search_message = 'Given Search Parameter(s): '
        @search.each {|key, value| search_message << "#{key}:'#{value}'; "}

        @permits = {}
        @permits[:search] = search_message

        permittees = Permit.search_for_contractors(@search)
        permittees = permittees.select("licensee_full_name").select("licensee_business_name").select("licensee_phone").select("licensee_license_kind").select("licensee_license_number")  
        permittees = permittees.select("max(permit_expiration_date) as freshness_date")
        permittees = permittees.group("licensee_full_name").group("licensee_business_name").group("licensee_phone").group("licensee_license_kind").group("licensee_license_number")
        # permittees = permittees.uniq
        permittees = permittees.order(permits_order) unless permits_order.blank?
        @permits[:permittees] =  permittees.paginate(:page => params[:page], :per_page => 10)
      end
    end 

    # flash[:notice] = "[**Start**]\n#{@permits.inspect}\n[**End**]"
    # get @search_parameters
    flash[:notice] = "[**Start**]\n#{params.inspect}\n[**End**]"
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
