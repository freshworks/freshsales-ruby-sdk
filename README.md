
#freshsales-ruby 

Freshsales Ruby Sdk Gem

 ==> gem 'freshsales-ruby', :git => 'git@github.com:freshdesk/freshsales-ruby-sdk.git'
 
 ==> include Freshsales    

 ==> Snippets for pushing data to Freshsales

   Configuration using Hash:

     params = {
       :api_key => "your frteshsales API key"
       :url => "your freshsales account url"
     }

    begin 
      Freshsales::configure(config)
    rescue Freshsales::Exceptions => exc
       p "#{exc.err_obj}: #{exc.message}"
    end


   Configuration using yaml file:

    begin 
      Freshsales::configure_with_yaml(File.join(Rails.root, 'config', 'your_file_name.yml'))
    rescue Freshsales::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end  


----------------------------------------------------------------------------------------------    
 
   Identify:
   
     sample_contact = { 
   
    "First Name" => "First" ,
    
    "Last Name" => "Last",
    
    "Job Title" => "Product Developer",
    
    "Website" => 'www.freshdesk.com',
    
    "City"  => 'Chennai',
    
    "State" => 'Tamilnadu',
    
    "Zipcode" => '600091',
    
    "Country" => 'India',
    
    "Custom 1"=> 'abcde abcde',
    
    "Discount Rate" => 10
    }
    
    
    begin
      Freshsales::identify("xyz@samplewebsite.com",sample_contact)
    rescue Freshsales::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end


-------------------------------------------------------------------------------------------------------

 Track Event:

    sample_event_properties = {
 
    "custom attr 0" => "abcdef ghijk" ,
    
    "contact" => {
    
       "Power User" => "Yes",
       
       "First Name" => "First",
       
       "Email" => "xyz@samplewebsite.com"
    },
    "company" => {
    
      "helpdesk url" => 'support.mycompany,com'       
    }
    }
    
    
    begin
      Freshsales::trackEvent("Reset password",sample_event_properties)
    rescue Freshsales::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end

-------------------------------------------------------------------------------------------------------
  
  Track page View:
  
    begin
      Freshsales::trackPageView("xyz@samplewebsite.com")
    rescue Freshsales::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end


                        


