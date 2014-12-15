
#freshsales-analytics 

Freshsales Ruby Sdk Gem

 ==> gem 'freshsales-analytics', :git => 'git@github.com:freshdesk/freshsales-ruby-sdk.git'
 
 ==> include FreshsalesAnalytics   

 ==> Snippets for pushing data to Freshsales

   Configuration using Hash:

     params = {
       :api_key => "your frteshsales API key"
       :url => "your freshsales account url"
     }

    begin 
      FreshsalesAnalytics::configure(config)
    rescue FreshsalesAnalytics::Exceptions => exc
       p "#{exc.err_obj}: #{exc.message}"
    end


   Configuration using yaml file:

    begin 
      FreshsalesAnalytics::configure_with_yaml(File.join(Rails.root, 'config', 'your_file_name.yml'))
    rescue FreshsalesAnalytics::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end  
    

    OR just create a file named fs_analytics_config.yml in your Rails Application in 'config' Folder and place the below code there.

        app_token: "your frteshsales API key"
        url: "your freshsales account url"

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
      FreshsalesAnalytics::identify("xyz@gmail.com",sample_contact)
    rescue FreshsalesAnalytics::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end


-------------------------------------------------------------------------------------------------------

  Track Event:

    sample_event_properties = {
    "custom attr 0" => "abcdef ghijk" ,    
    "contact" => {    
       "Power User" => "Yes",      
       "First Name" => "First",       
       "Email" => "xyz@samplewebsite.com",
       "company" => {   
           "helpdesk url" => 'support.mycompany,com'       
       }
    }
    
    }
    
    
    begin
      FreshsalesAnalytics::trackEvent("xyz@gmail.com","Reset password",sample_event_properties)
    rescue FreshsalesAnalytics::Exceptions => exc
      p "#{exc.err_obj}: #{exc.message}"
    end

-------------------------------------------------------------------------------------------------------

  Set Properties:

    sample_set_properties = {
    "contact" => {
      "Discount Rate" => '+10'
    },
    "company" => {
      "Name" => "ABC",
      "Number of Agents" => '+1'
    },
    "opportunity" => {
       "Name" => "abcdef",
       "Amount" => '100'
    }
    }
                        
    begin
        FreshsalesAnalytics::set("xyz@gmail.com",sample_set_properties)
    rescue FreshsalesAnalytics::Exceptions => exc
        p "#{exc.err_obj}: #{exc.message}"
    end

