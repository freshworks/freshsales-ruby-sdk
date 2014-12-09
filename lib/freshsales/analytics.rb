require "freshsales/analytics/version"

module FreshsalesAnalytics
 class Exceptions < StandardError
     attr_reader :err_obj 
     def initialize(err_obj) 
        @err_obj = err_obj 
     end
  end

  @config = {
              :app_token => nil,
              :url => nil
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

  def self.identify(identifier, contact_properties = {})
    if validate(identifier:identifier, contact_properties:contact_properties)
      custom_data = Hash.new
      custom_data["contact"]  = contact_properties
      custom_data["identifier"] = identifier
      post_data("identify",custom_data)
    end   
  end

  def self.set(identifier, set_properties={})
    if validate(identifier:identifier,set_properties:set_properties)
      custom_data = Hash.new
      custom_data["identifier"] = identifier
      custom_data["set"] = set_properties
      post_data("set",custom_data) 
    end
  end

  def self.trackEvent(identifier, event_name, event_properties = {})
    if validate(identifier:identifier,event_name:event_name,event_properties:event_properties)
      event_properties["name"] = event_name
      custom_data = Hash.new
      custom_data["identifier"] = identifier
      custom_data["event"] = event_properties
      post_data("trackEvent",custom_data)
    end
  end

  def self.trackPageView(identifier, page_url)   
    if validate(identifier:identifier,page_url:page_url)
      custom_data = Hash.new
      custom_data["identifier"] = identifier
      custom_data["page_view"] = {:url => page_url}
      post_data("trackPageView",custom_data)
    end
  end

  def self.post_data(action_type, data)
    url = @config[:url]
    app_token = @config[:app_token]
    if url.nil? || app_token.nil?
      configure_with_yaml(File.join(Rails.root, 'config', 'fs_analytics_config.yml'))
      url = @config[:url]
      app_token = @config[:app_token] 
    end

    data = preprocess_posting_data(data)
    begin
      p "before post :::::: in ruby gem"
    response = HTTParty.post(url+"/"+"track/post_data",
      :body => {:application_token => app_token,
              :action_type => action_type,
              :sdk => "ruby",
              :freshsales_data => data}.to_json,
      :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'}) 
      p "after post :::::: in ruby gem"
     if response.code != 200
      raise Exceptions.new("Data not sent"),"Data is not sent to Freshsales because of the error code "+response.code.to_s
     end
    rescue Timeout::Error
       p "Could not post to #{url}: timeout"
    end   
  end

  def self.validate(params = {})
    if params.has_key?(:identifier) && params[:identifier].blank?
      raise Exceptions.new("Missing Email Parameter"),"Identifier(eg:Email) must be present!!!"
    elsif params.has_key?(:event_name) && params[:event_name].blank?
      raise Exceptions.new("Missing Event name Parameter"),"Event name must be present in trackEvent method!!!"
    elsif params.has_key?(:page_url) && params[:page_url].blank?
      raise Exceptions.new("No Page Url"),"Page url to track is not set!!!"
    elsif params.has_key?(:set_properties) &&  params[:set_properties].blank?
      raise Exceptions.new("Missing set properties"),"set properties are blank so,nothing to set!!!"
    else        
      return true
    end
  end

  def preprocess_posting_data(data)
    if !data["event"].nil?
     if !data["event"]["contact"].nil?
      data["contact"] = data["event"]["contact"]
      data["event"].delete("contact")
     end  
    end

    if !data["set"].nil?
      if data["set"].has_key?("company")
        data["set"]["contact"] ||= {}
        data["set"]["contact"]["company"] = data["set"]["company"]
        data["set"].delete("company")
      end
      if data["set"].has_key?("opportunity")
        data["set"]["contact"] ||= {}
        data["set"]["contact"]["opportunity"] = data["set"]["opportunity"]
        data["set"].delete("opportunity")
      end
    end    
    data
  end
end
