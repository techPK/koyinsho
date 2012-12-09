# lib/tasks/nyc_permits.rake

namespace :excel_data do
   #----------------------------------------------------
  desc "Collect excel Permit file names"
  task :permit do
    class NycGovExcelWebfile < ActiveRecord::Base
      validates_presence_of :updated_at
    end
    class PermitExcelWebfile < NycGovExcelWebfile
  # STI
    end

    puts "Environment Check: Rails ENV = #{Sinatra::Application.environment}"
     puts "Excel file count = #{NycGovExcelWebfile.count}"
     process_excel_filename_collection('permit_base_url', 'permit_start_date', PermitExcelWebfile)
  end  
  #----------------------------------------------------
  desc "Collect excel Permit-Job file names"
  task :job  do
    puts "Environment Check: Rails ENV = #{Sinatra::Application.environment}"
    puts "Excel file count = #{NycGovExcelWebfile.count}"
    process_excel_filename_collection('job_base_url', 'job_start_date', JobExcelWebfile)
  end  
  #----------------------------------------------------
  desc "Collect excel Sign Report file names"
  task :sign  do
    puts "Environment Check: Rails ENV = #{Sinatra::Application.environment}"
    puts "Excel file count = #{NycGovExcelWebfile.count}"    
    process_excel_filename_collection('sign_base_url', 'sign_start_date', SignExcelWebfile)
  end
   #---------------------------------------------------- 
  desc "Collect excel Antenna file names"
  task :antenna do
    puts "Environment Check: Rails ENV = #{Sinatra::Application.environment}"
    puts "Excel file count = #{NycGovExcelWebfile.count}"    
    process_excel_filename_collection('antenna_base_url', 'antenna_start_date', AntennaExcelWebfile)
  end
   #----------------------------------------------------  
  def process_excel_filename_collection(env_base_url, env_start_date, model)
      base_url = ENV[env_base_url] ###----Bingo
    if base_url.blank? 
      puts "Did not receive a value for #{env_base_url}"  ###----Bingo 
    end
    
    date_base = nil
    if ENV[env_start_date].blank?  ###----Bingo
      puts "Did not receive a value for #{env_start_date}"  ###----Bingo
    else
      start_date = ENV[env_start_date].match(/[0-9]*/).to_s  ###----Bingo
      if start_date.blank? || ((start_date.size < 5 ) | (start_date.size > 6)) 
        puts "Given '#{start_date}' for #{env_start_date} not having format of 'mddyy' or 'mmddyy'"  ###----Bingo
      else
        yyyy = 2000 + start_date[-2,2].to_i
        mm = start_date.size == 5 ? start_date[0,1].to_i : start_date[0,2].to_i
        dd = start_date[-4,2].to_i
        if !(Date.valid_date? yyyy, mm, dd) 
          puts "Given '#{start_date}' for #{env_start_date} is not a valid date."  ###----Bingo
        else
          date_base = Date.new(yyyy, mm, dd)
        end
      end
    end
    
    puts "date_base:#{date_base.to_s}"
    puts "base_url:#{base_url}"
    puts "model:#{model}"
    
    verified_count = 0
    if base_url.present? & date_base.present?
      verified_count = verify_and_save_url_for_later(date_base,base_url,model)  ###----Bingo
    end
    
    puts "Finished. Found #{verified_count} new excel webfiles."
 
  end
#----------------------------------------------------  
  def verify_and_save_url_for_later(date_base,base_url,model)
    max_date_base = model.maximum('date_base')
    if max_date_base.blank?
      text_date = date_base.to_s[6,1] + date_base.to_s[-2,2] + date_base.to_s[2,2]
    else
      date_base ||= max_date_base + 1
      date_base = max_date_base unless date_base > max_date_base
      text_date = date_base.to_s[5,2] + date_base.to_s[-2,2] + date_base.to_s[2,2]
    end  
    
    failed_count = 0
    verified_count = 0
    
    while date_base < Date.today
      text_url = base_url + text_date + ".xls" 
      
      url = URI.parse(text_url)
      Net::HTTP.start(url.host,url.port) do |http|
        if http.active? && http.head(url.request_uri).code == '200'
          if model.where("date_base = '#{date_base}'").empty?
            webfile = model.new(updated_at:DateTime.now,created_at:DateTime.now)
            webfile.date_base = date_base 
            webfile.full_url = text_url          
            if webfile.save
              puts "Found '#{text_url}' for later processing."
              verified_count += 1
              failed_count = 0
            else
              puts "Found '#{text_url}' but could not save it."
            end
          else
            puts "Found '#{text_url}' but it was prevoiusly processed."
          end
        else
          failed_count += 1
        end
      end
     
      if failed_count > 25
        puts "failed_count exceeded 25"
        return verified_count
      end
      
      date_base += 1 # next date_base 
      text_date = date_base.to_s[5,2] + date_base.to_s[-2,2] + date_base.to_s[2,2] 
    end 
    verified_count
  end  
   #----------------------------------------------------
end
