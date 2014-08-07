require "freshsales/ruby/version"
require "yaml"

module Freshsales
  

  class Exceptions < StandardError
     attr_reader :err_obj 
     def initialize(err_obj) 
        @err_obj = err_obj 
     end
  end

  @config = {
              :app_token => "",
              :url => ""
            }

  @valid_config_keys = @config.keys

  def self.configure(opts = {})
    opts.each do |k,v|  
      if @valid_config_keys.include?k.to_sym
        @config[k.to_sym] = v
      else
         raise Exceptions.new("Error in configuration"),k.to_s+" is not present in the configuration settings keys list"
      end
    end  
  end

  def self.configure_with_yaml(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      raise Exceptions.new(),"YAML configuration file couldn't be found."
    rescue Psych::SyntaxError
      raise Exceptions.new(),"YAML configuration file contains invalid syntax."
    end 
    configure(config)
  end

  def self.identify(identifier, contact_properties=nil)
    if identifier.blank?
      raise Exceptions.new("Missing Email Parameter"),"Identifier(eg:Email) must be present to call identify method"
    else
  	  contact_properties["Email"] = identifier
    end
  	custom_data = Hash.new
    custom_data["contact"]  = contact_properties
    post_data("identify",custom_data) 
  end

  def self.set(contact_properties=nil)
    custom_data = Hash.new
    custom_data["contact"]  = contact_properties
    post_data("set",custom_data) 
  end

  def self.trackEvent(event_name=nil,event_properties=nil)
    if event_name.blank? 

  def self.trackEvent(event_name,event_properties=nil)
    if event_name.blank?
      raise Exceptions.new("Missing Event name Parameter"),"Event name must be present to call trackEvent method"
    elsif !event_properties["contact"].has_key?("Email")
      raise Exceptions.new("Missing Email key"),"Email key must be present in 'contact' hash of 'event' to call trackEvent method"
    else
      event_properties["name"] = event_name
    end
    custom_data = Hash.new
  	custom_data["event"] = event_properties
    post_data("trackEvent",custom_data)
  end

  def self.trackPageView(identifier,page_view_data=nil,post_page_view=true)  
    if identifier.blank?
      raise Exceptions.new("Missing Email Parameter"),"Identifier(eg:Email) must be present to call trackPageView method"
    else
      if post_page_view
        if page_view_data.blank?
           custom_data = Hash.new
           custom_data["contact"] = {"Email" => identifier} 
           post_data("trackPageView",custom_data)
        else
          #handle the data provided
        end
      else
        raise Exceptions.new("Not set to true"),"Posting Page view is not set to true so can't track the page"
      end 
    end  
  end

  def post_data(action_type,data)
    url = @config[:url]
    app_token = @config[:app_token]

    if !data["event"].nil?
     if !data["event"]["contact"].nil?
      data["contact"] = data["event"]["contact"]
      data["event"].delete("contact")
     end  
    end

    response = HTTParty.post(url+"/"+"track/post_data",
      :body => {:application_token => app_token,
              :action_type => action_type,
              :sdk => "ruby",
              :freshsales_data => data}.to_json,
      :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'}) 
    if response.code != 200
      raise Exceptions.new("Data not sent"),"Data is not sent to Freshsales because of the error code "+response.code.to_s
    end
    
  end


  # def getSessionInfoAndPostData(identifier)
  #   #these things like app_token,url has to be given in a yml file for each application.
  #   app_token = "aKK7bI9b-zawm6w-Ee_GpQ"
  #   url = "http://account1.freshdesk-dev.com:3000"
  #   data = Hash.new
  #   d 
  #   response = HTTParty.post(url+"/"+"track/page_view",
  #     :body => {:application_token => app_token,
  #             :action_type => "trackPageView",
  #             :sdk => "ruby",
  #             :visitor_profile => data}.to_json,
  #     :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'}) 
  #   if response.code != 200
  #     raise SdkErrors.new("Data not sent"),"Data is not sent to Freshsales because of the error code "+response.code.to_s
  #   end
  # end

  #  def setCookie
  #   app_token = "aKK7bI9b-zawm6w-Ee_GpQ"
  #   url = "http://account1.freshdesk-dev.com:3000"

  #   response = HTTParty.get(url+"/"+"track/FreshAnalytics.rb",
  #     :body => {:application_token => app_token,
  #             :action_type => "setCookie",
  #             :sdk => "ruby"}.to_json,
  #     :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

  # end

  
end
