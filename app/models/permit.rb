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

end
