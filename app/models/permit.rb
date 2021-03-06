class Permit < ActiveRecord::Base
  belongs_to :property_building
  belongs_to :licensed_contractor
  #accepts_nested_attributes_for :property_building
  attr_accessible :permit_kind, :permit_subkind, :permit_job_number, :permit_issuance_date
  attr_accessible :owner_full_name, :owner_business_name, :owner_business_kind, :owner_street_address, :owner_city_state, :owner_zipcode, :owner_phone, :owner_is_non_profit
  attr_accessible :licensee_full_name, :licensee_business_name, :licensee_license_kind, :licensee_license_number, :licensee_license_HIC_number, :licensee_phone
  validates_uniqueness_of :permit_job_number

  
  def self.search_for_contractors(search_params={})
    # Start ActiveRecord query

    permits = Permit.scoped

    search_params.each do |key,value| 
      case key
        #Property location
        when :borough.to_s then permits = permits.joins(:property_building).where(:property_buildings => {borough:value})
        when :block.to_s then permits = permits.joins(:property_building).where(:property_buildings => {block:value})
        when :lot.to_s then permits = permits.joins(:property_building).where(:property_buildings => {lot:value})
        when :zipcode.to_s then permits = permits.joins(:property_building).where(:property_buildings => {zip_code:value})
        when :street.to_s then permits = permits.joins(:property_building).where(:property_buildings => ("lower(street_name) = '#{value.downcase}'"))
        when :address_number.to_s then permits = permits.joins(:property_building).where(:property_buildings => {house:value})
        when :community_district.to_s then permits = permits.joins(:property_building).where(:property_buildings => {community_board:value})
        #Other
        when :license_type.to_s then permits = permits.joins(:licensed_contractor).where(:licensed_contractors => {license_type:value})
        when :permit_type.to_s
          permits = permits.where(permit_kind:value[0,2])
          permits = permits.where(permit_subkind:value[3,2]) if value.size > 2
        else
          puts "[Permit.search_for_contractors] else>>>#{key}:#{value}|<<<"
      end
    end 
    # contractors[:permits] = permits 
    contractors = []
    permits.each {|permit| contractors << permit.licensed_contractor_id unless permit.licensed_contractor_id.nil?}		
    LicensedContractor.find(contractors.uniq)
  end
  
  def self.search_for_owners(search_params={})
  end

  def self.create_or_update_permit(permit_issued = {})
    permit_issued.each do |key,value| 
      # puts ">>#{key}; state= #{Permit.attribute_names.include?(key)}" # test
      unless Permit.attribute_names.include?(key.to_s)
        return "Key '#{key}' is not valid as Permit attribute"
      end
    end
    permit = Permit.where(permit_job_number:permit_issued[:permit_job_number]).first_or_initialize
    permit.permit_issuance_date ||= Date.new

    return "'permit_issuance_date' must be valid date" unless permit_issued[:permit_issuance_date].class == Date

    if (permit.permit_issuance_date < permit_issued[:permit_issuance_date])
      permit_issued.each do |key,value|
        unless permit_issued[key] == permit[key]
          permit[key] = permit_issued[key]
        end
      end
      if permit.valid?
          permit.save  
      else
        return "Permit record is not valid" 
      end   
    end
    nil
  end


  def self.process_permits(xls_permit_url, broadway_only = false)

    #Give Permit model/column name map
    permit_model_xls_xref = 
      { 
        #property_bin_number:'Bin #', 
        property_borough:'Borough', 
        property_block_number:'Block', 
        property_lot_number:'Lot', 
        property_community_district_number:'Community Board', 
        property_address_number:'House #', 
        property_street:'Street Name', 
        property_zipcode:'Zip Code', 
        #property_residential:'Residential', Boolean
          
        owner_full_name:"Owner's First & Last Name", 
        owner_business_name:"Owner's Business Name", 
        owner_business_kind:"Owner's Business Type", 
        owner_street_address:"Owner's House Street", 
        owner_city_state_zipcode:"City, State, Zip", # Need to stripout zip
        # owner_city_state:"City, State, Zip", # Need to stripout zip
        # owner_zipcode:"City, State, Zip", # Need to stripout city state
        owner_phone:"Owner's Phone #", 

        permit_kind:'Permit Type', 
        permit_subkind:'Permit Subtype', 
        # permit_oil_or_gas:'Oil Gas', # Only for permit_kind='EW' and permit_subkind='FB'
        licensee_full_name:"Permittee's First & Last Name", 
        licensee_business_name:"Permittee's Business Name", 
        licensee_license_kind:"Permittee's License Type", 
        licensee_license_number:"Permittee's License #", 
        licensee_license_HIC_number:"HIC License", 
        licensee_phone:"Permittee's Phone #", 
       
        #permit_job_kind:'Job Type',
        permit_job_number:'Job #', 
        owner_is_non_profit:'Non-Profit', #boolean 
        permit_issuance_date:'Issuance Date' 
      }

    xls_row_errors = []

    xls_permits = Excel.new(xls_permit_url)

    header = xls_permits.row(3)
    
    header.map! {|key|  key != key.strip ? key.strip : key } 
    
    puts ">>>header == #{header} " # testing...

    #ActiveRecord::Base.transaction do
      (4..(xls_permits.last_row + 1)).each do |i|
        row = Hash[[header,xls_permits.row(i)].transpose]
        data_row = row.slice(*permit_model_xls_xref.values)
        #replace key with model field name
        permit_model_xls_xref.each do |key,value|
          
          next if data_row[value] == nil

          if data_row[value]
            if (data_row[value].class == Float) && (data_row[value] == data_row[value].to_i)
              data_row[key] = data_row[value].to_i.to_s
            else
              data_row[key] = data_row[value]
              data_row[key].strip! if data_row[key].class == String
            end
            data_row.delete(value)
          end

          if key.to_s.end_with?('_full_name')
            splited_text = data_row[key].split(' ')
            if splited_text.size >= 2
              data_row[key] = splited_text.last + ', ' + splited_text[0..(splited_text.size - 2)].join(' ')
            end          
          end
        end
        
        if broadway_only 
          broadway_count ||= 0
          if data_row[:property_street] &&
              data_row[:property_street].downcase.include?('broadway')
            broadway_count += 1
          else
            next
          end
        end

        if data_row[:owner_city_state_zipcode]
          zipcode_regex ||= Regexp.new(/[0-9]{5}(-[0-9]{4})?$/)
          splited_text = data_row[:owner_city_state_zipcode].split(' ')
          if splited_text.last.match(zipcode_regex)
            data_row[:owner_zipcode] = splited_text.last
            data_row[:owner_city_state] = splited_text[0..(splited_text.size - 2)].join(' ')
          else
            data_row[:owner_zipcode] = '00000'
            data_row[:owner_city_state] = data_row[:owner_city_state_zipcode]
          end
          data_row.delete(:owner_city_state_zipcode)
        end

        error_message = Permit.create_or_update_permit(data_row)   
        xls_row_errors << error_message if error_message
        if xls_row_errors.size > 10
          xls_row_errors << 'Too many Permit create errors!!!'
          break
        end
      end
    # end #ActiveRecord::Base.transaction
      xls_row_errors.size > 0 ? xls_row_errors : nil 
  end # end of def self.process_permits



end
