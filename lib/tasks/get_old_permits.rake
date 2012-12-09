# lib/tasks/nyc_data_upload.rake

namespace :excel_data do
   #----------------------------------------------------
  desc "Upload NYC excel spreadsheet data"
  task :upload do
    class NycGovExcelWebfile < ActiveRecord::Base
      validates_presence_of :updated_at
    end
    class PermitExcelWebfile < NycGovExcelWebfile
  # STI
    end
    class XrefTitles < ActiveRecord::Base
      validates_presence_of  :computed_key, :subsitute_key
    end
    class Permit < ActiveRecord::Base
      validates_presence_of  :job_integer, :job_document_number
    end

    require 'roo'
    
    puts "NycGovExcelWebfile unprocessed #{NycGovExcelWebfile.where(processed:true).count} of #{NycGovExcelWebfile.count}"
    
    broadway_only= nil
    excel_files = NycGovExcelWebfile.where(processed:nil).order("date_base ASC, type DESC")   
      
    # get unprocessed excel url name
    # puts "rook 001" # testing
    titles = Hash.new
    data_row = Hash.new 
    
    excel_files_ct = 0
    excel_files.each do |unprocessed|
      puts "rook 010: #{unprocessed.full_url}" # testing
      spreadsheet = Excel.new(unprocessed.full_url)
      titles.clear
      (spreadsheet.last_row + 1).times do |row| 
        data_row.clear
        if row == 3
          (spreadsheet.last_column + 1).times do |column|
            if spreadsheet.cell(row,column).present?
              title = spreadsheet.cell(row,column).to_s.delete("'").strip.squeeze(' ').downcase.to_sym
              xref_title = XrefTitles.where("computed_key = '#{title}'").first
              title = xref_title.subsitute_key.to_sym if xref_title.present?
              titles[title] =  column 
            end
          end
        end

        if row > 3 # get column values from each row
           titles.each do |title, column|
            if spreadsheet.cell(row,column).present?
              case spreadsheet.celltype(row,column)
                when :string
                  data_row[title] = spreadsheet.cell(row,column).strip.squeeze(' ')
                when :float
                  data_row[title] = spreadsheet.cell(row,column) unless spreadsheet.cell(row,column).zero?
                else
                  data_row[title] = spreadsheet.cell(row,column)
              end
            end     
          end
          
          data_row[:date_base] = unprocessed.date_base
          data_row[:source] = unprocessed.type 
          data_row[:created_at] = unprocessed.created_at
          data_row[:updated_at] = DateTime.now 

         # puts "**>data_row 1 = '#{data_row.inspect}'" # if (4..7) === row #testing

          # Correct/Remove invalid datatype
          data_row.each do |key,value|
            if key.to_s.downcase.rindex('_date',-5).present?
              if !value.is_a?(Date)
                puts "#{key}:'#{value}' is not a Date"
                data_row.delete(key)
              end
            end
            if key.to_s.downcase.rindex('_name',-5).present?
              if value.is_a?(String)
                data_row[key] = value.split(' ').each{|word| word.capitalize!}.join(' ')
              end
            end
            if key.to_s.downcase.rindex('_number',-7).present?
              if value.is_a?(String)
                data_row[key] = value.gsub(/\D/, '')
              else
                data_row[key] = value.to_i.to_s.gsub(/\D/, '') #updated with to_i to correct phone #
              end
            end
          end
          
         # puts "***>>data_row 2 = '#{data_row.inspect}'" # if (4..5) === row #testing

          #Test if already processed this excel file
          if row > 1
            been_here = nil
          else
            if data_row[:source].index("Permit")
              been_here = Permit.where({date_base:data_row[:date_base],source:data_row[:source]})
            # else
            #  been_here = PermitDetail.where({date_base:data_row[:source],source:data_row[:source]})
            end
          end        
          
          saved_count = process_permits(data_row,broadway_only, been_here)  
        end      
      end
    spreadsheet.remove_tmp
    if broadway_only.present?
      unprocessed.broadway_test = true
    else  
      unprocessed.processed = true
    end
    unprocessed.save
    excel_files_ct += 1
    if excel_files_ct > 5
      puts ">>Permit.count == #{Permit.count}"   
      abort("processing too much")  ###> Testing 
    end
  end
      puts "excel_files_ct == #{excel_files_ct}"
      puts "rook DONE!! saved_count = #{saved_count}" # testing
end 

#----------------------------------------------------
  def process_permits(excel_data_row_hash, broadway_only, been_here=nil)
    
    
    saved_count = 0
    
    permit_key_fields = [
      :job_integer,
      :job_document_number,
      :date_base,
      :source]
          
    permit_fields = [
      :bin_integer,
      #Purpose
      :permit_kind,
      :permit_subtype,
      #Dates
      :expiration_date,
      :job_start_date,
      :approved_date,
      #location
      :borough,
      :community_board_integer,
      :property_block_integer,
      :property_lot_integer,
      :property_house_number,
      :property_street_name,
      :property_zip_code,
      #Permittee
      :permittees_business_name,
      :permittees_first_and_last_name,
      :permittees_license_integer,
      :permittees_license_kind,
      :permittees_other_title,
      :permittees_phone_number,
      #Managers
      :site_safety_manager_business_name,
      :site_safety_managers_name,
      :superintendent_business_name,
      :superintendent_first_and_last_name,
      #Owner
      :owners_business_name,
      :owners_business_kind,
      :owners_city_state_zip,
      :owners_first_and_last_name,
      :owners_house_street,
      :owners_phone_number,
      #DB House Keeping
      :created_at,
      :updated_at
      ]
  

    if broadway_only.present? 
      street_value = excel_data_row_hash[:property_street_name].to_s
      if street_value.downcase.index('broadway').present?
        puts "#{property_data[:property_house_number]} #{street_value} in #{property_data[:borough]} [#{excel_data_row_hash[:source]} #{excel_data_row_hash[:date_base].to_s}]" # testing
      else
        return 0
      end
    end
   
    if excel_data_row_hash[:source].index("Permit")
      permit_keys = excel_data_row_hash.select{|key,value| permit_key_fields.include?(key)}
      been_here_count = Permit.where(permit_keys).count
      permit_data_fields = permit_key_fields + permit_fields
    end
    
    if been_here_count > 0
      puts "**** Been Here **** #{permit_keys}"
      return 0
    end
      
    permit_data = excel_data_row_hash.select {|key,value| permit_data_fields.include?(key) } 
    
    if excel_data_row_hash[:source].index("Permit")
      if Permit.create(permit_data)
        saved_count += 1
      else
        puts "**** permit not saved ****"
        puts permit_data
        abort("**** permit not saved ****")
      end
    end
    
    saved_count
  end

  ##########------------------------------------- 
end 
