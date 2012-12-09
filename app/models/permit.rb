class Permit < ActiveRecord::Base
  attr_accessible :property_block_number, :property_borough, :property_lot_number
  validates_uniqueness_of :permit_job_number
  
  def self.search_for_contractors(search_params={})
    # Start ActiveRecord query

    permits = Permit.scoped

    search_params.each do |key,value| 
      case key
        when :borough.to_s then permits = permits.where(property_borough:value)
        when :block.to_s then permits = permits.where(property_block_number:value)
        when :lot.to_s then permits = permits.where(property_lot_number:value)
        when :zipcode.to_s then permits = permits.where(property_zipcode:value)
        when :street.to_s then permits = permits.where("lower(property_street) = '#{value.downcase}'")
        when :address_number.to_s then permits = permits.where(property_address_number:value)
        when :community_district.to_s then permits = permits.where(property_community_district_number:value)
        when :license_type.to_s then permits = permits.where(licensee_license_kind:value)
        when :permit_type.to_s
          permits = permits.where(permit_kind:value[0,2])
          permits = permits.where(permit_subkind:value[3,2]) if value.size > 2
        else
          puts "[Permit.search_for_contractors] else>>>#{key}:#{value}|<<<"
      end
    end 
    # contractors[:permits] = permits 
    permits		
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

  def self.borough_check(borough_text, borough_zipcode, borough_community_district)
    borough_id =
      [
        [1, 'Manhattan',[100, 102]],
        [2, 'Bronx', [104]],
        [3, 'Brooklyn', [112]],
        [4, 'Queens', [111, 113, 114, 116]], 
        [5,'Staten Island',[103]]
      ]
    borough_check = {}
    unless borough_community_district.nil? || borough_community_district == ''
      borough_check[:community_district] = borough_community_district.gsub(/\D/, '')[0].to_i
    end
    borough_check[:borough] = 98 unless borough_text.nil? || borough_text == ''
    borough_check[:zipcode] = 99 unless borough_zipcode.nil? || borough_zipcode == ''
    borough_id.each do |id, text, zip_prefixes|
      borough_check[:borough] = id if borough_text.present? && text.downcase == borough_text.downcase
      borough_check[:zipcode] = id if borough_zipcode.present? && zip_prefixes.include?(borough_zipcode.gsub(/\D/, '')[0,3].to_i)
    end
    
    if borough_check.count < 1
      return nil
    elsif borough_check.count == 1
      borough_check.each do |key, value|
        if (1..5) === value
          return nil
        else
          flash_message = "Specified #{key.to_s} is not valid for NYC."
          return flash_message 
        end        
      end
    elsif borough_check.count > 1
      borough_inconsistancies = 0
      if borough_check[:community_district].present? && borough_check[:borough].present?
        if borough_check[:community_district] != borough_check[:borough]
          borough_inconsistancies += 1
        end
      end
      if borough_check[:borough].present? && borough_check[:zipcode].present?
        if borough_check[:borough]  != borough_check[:zipcode]
          borough_inconsistancies += 1
        end
      end
      if borough_check[:zipcode].present? && borough_check[:community_district].present?
        if borough_check[:zipcode] != borough_check[:community_district]
          borough_inconsistancies += 1
        end
      end
      if borough_inconsistancies > 0
        if borough_check[:zipcode].present?
          flash_message = " and Zipcode."
          if borough_check[:borough].present?
            flash_message = " Borough" + flash_message
            if borough_check[:community_district].present?
              flash_message = " Community-District," + flash_message
            end
          else
            flash_message = " Community-District" + flash_message
          end
        else
          flash_message = " Community-District and Borough"
        end  
        return flash_message = "Inconsistancy with" + flash_message
      else
        nil
      end
    end
  end

  def self.process_permits(xls_permit_url, broadway_only)
    #Give Permit model/column name map
    permit_model_xls_xref = 
      { 
        #property_bin_number:'Bin #', 
        property_borough:'BOROUGH'.downcase, 
        property_block_number:'Block'.downcase, 
        property_lot_number:'Lot'.downcase, 
        property_community_district_number:'Community Board'.downcase, 
        property_address_number:'House #'.downcase, 
        property_street:'Street Name'.downcase, 
        property_zipcode:'Zip Code'.downcase, 
        #property_residential:'Residential', Boolean
          
        owner_full_name:"Owner's First & Last Name".downcase, 
        owner_business_name:"Owner's Business Name".downcase, 
        owner_business_kind:"Owner's Business Type".downcase, 
        owner_street_address:"Owner's House Street".downcase, 
        owner_city_state_zipcode:"City, State, Zip".downcase, # Need to stripout zip
        # owner_city_state:"City, State, Zip", # Need to stripout zip
        # owner_zipcode:"City, State, Zip", # Need to stripout city state
        owner_phone:"Owner's Phone #".downcase, 

        permit_kind:'Permit Type'.downcase, 
        permit_subkind:'Permit Subtype'.downcase, 
        # permit_oil_or_gas:'Oil Gas', # Only for permit_kind='EW' and permit_subkind='FB'
        licensee_full_name:"Permittee's First & Last Name".downcase, 
        licensee_business_name:"Permittee's Business Name".downcase, 
        licensee_license_kind:"Permittee's License Type".downcase, 
        licensee_license_number:"Permittee's License #.downcase", 
        licensee_license_HIC_number:"HIC License".downcase, 
        licensee_phone:"Permittee's Phone #".downcase, 
       
        #permit_job_kind:'Job Type',
        permit_job_number:'Job #'.downcase, 
        owner_is_non_profit:'Non-Profit'.downcase, #boolean 
        permit_issuance_date:'Issuance Date'.downcase 
      }
    puts "****> process_permits: Location 01 *****" # Testing

    xls_row_errors = 0
    xls_title_row_processed = false
    xls_titles = {}
    xls_permits = Excel.new(xls_permit_url)

    (xls_permit.last_row + 1).times do |row|
      break if row > 13 # Testing
      puts "****> process_permits: Location 02 *****" if row < 5# Testing      
      if (xls_title_row_processed == false) && (row > 3) 
        puts "Given Url '#{xls_permit_url}' did not have Permit xls title row!"
        return nil
      end
     
      if (xls_title_row_processed == false) 
        puts "****> process_permits: Location 03 *****"  if row < 5 # Testing
        # Detect Title row?
        if (xls_permits.cell(row,1).present?) && (xls_permits.cell(row,1).strip.squeeze(' ').downcase == 'borough') 
          # ID each column and map name to Permit model field name
          (spreadsheet.last_column + 1).times do |column|
            puts "*****> xls title has #{xls_permits.cell(row,column)} with type #{xls_permits.celltype(row,column)}" unless xls_permits.celltype(row,column) == :string
            title = xls_permits.cell(row,column).strip.squeeze(' ').downcase
            matched_key = permit_model_xls_xref.key(title)          
            xls_titles[matched_key] = column if matched_key 
            puts "*****> xls title has #{xls_permits.cell(row,column)} that has no match in permit_model_xls_xref"  if matched_key.nil?
          end
          xls_title_row_processed = true
        end
      end  

      next unless xls_title_row_processed 
      
      puts "****> process_permits: Location 04 *****"  if row < 5 # Testing
      data_row = {}
      xls_titles.each do |title, column|
        case xls_permits.celltype(row,column)
        when :string
          selected_string = xls_permits.cell(row,column).strip.squeeze(' ')
          puts "****> process_permits: Location 04.1 #{title}:#{selected_string} *****"  if row < 5 # Testing                
          if title.end_with?('_full_name')
            splited_name = selected_string.split(' ')
            if splited_name.size < 2
              data_row[title] = selected_string
            else
              data_row[title] = splited_name.last + ', ' + splited_name[0..(splited_name.size - 2)].join(' ')
            end
          elsif title.end_with?('_zipcode')
            zipcode_regex = Regexp.new(/[0-9]{5}(-[0-9]{4})?$/)
            if title == :owner_city_state_zipcode
              splited_name = selected_string.split(' ')
              if splited_name.last.match(zipcode_regex)
                data_row[:owner_zipcode] = splited_name.last
                data_row[:owner_city_state] = splited_name[0..(splited_name.size - 2)].join(' ')
              else
                data_row[title] = selected_string
              end
            else
              data_row[title] = selected_string
            end
          else
            data_row[title] = selected_string
          end
        when :float
          selected_number = xls_permits.cell(row,column)
          puts "****> process_permits: Location 04.2 #{title}:#{selected_number} *****"  if row < 5 # Testing                
          if selected_number && (selected_number != 0) 
            selected_number = selected_number.to_i if selected_number == selected_number.to_i
            if title.end_with?('_phone')
              textized_number = "%d" % selected_number
              if textized_number.size == 10
                data_row[title] = textized_number[0,3] + '-' + textized_number[3,3] + '-' + textized_number[6,4]
              else
                data_row[title] = textized_number
              end
            elsif title.end_with?('_zipcode')
              textized_number = "%d" % selected_number
              if textized_number.size <= 5
                data_row[title] = "%05d" % selected_number
              else 
                data_row[title] = textized_number[0,5] + '-' + textized_number[6,4]
              end
            else # title.end_with?('_address_number')
              data_row[title] = textized_number
            end
          end
        else
          puts "****** Unknown celltype ='#{xls_permits.celltype(row,column)}' *****"
          data_row[title] = xls_permits.cell(row,column)
        end       
        #add_or_update to Permits
        error_message = Permit.create_or_update_permit(data_row)
        puts error_message unless error_message.nil?
        xls_row_errors += 1 unless error_message.nil?         
      end # columns
    end # rows
    xls_row_errors > 0 ? xls_row_errors : nil

  end # end of def self.process_permits



end
