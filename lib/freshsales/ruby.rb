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
    if validate(identifier: identifier)
  	  contact_properties["Email"] = identifier
  	  custom_data = Hash.new
      custom_data["contact"]  = contact_properties
      post_data("identify",custom_data)
    end   
  end

  def self.set(contact_properties=nil)
    custom_data = Hash.new
    custom_data["contact"]  = contact_properties
    post_data("set",custom_data) 
  end

  def self.trackEvent(event_name,event_properties = {})
    if validate(event_name:event_name,event_properties:event_properties)
      event_properties["name"] = event_name
      custom_data = Hash.new
  	  custom_data["event"] = event_properties
      post_data("trackEvent",custom_data)
    end
  end

  def self.trackPageView(identifier,page_view_data=nil,post_page_view=true)  
 
      if validate(identifier:identifier,post_page_view:post_page_view)
        if page_view_data.blank?
           custom_data = Hash.new
           custom_data["contact"] = {"Email" => identifier} 
           post_data("trackPageView",custom_data)
        else
          #handle the data provided
        end
      end
  end

  def post_data(action_type,data)
    url = @config[:url]
    app_token = @config[:app_token]
    if url.nil? || app_token.nil?
      configure_with_yaml(File.join(Rails.root, 'config', 'fs_analytics_config.yml'))
      url = @config[:url]
      app_token = @config[:app_token] 
    end
    if !data["event"].nil?
     if !data["event"]["contact"].nil?
      data["contact"] = data["event"]["contact"]
      data["event"].delete("contact")
     end
     if !data["contact"].nil? && !data["event"]["company"].nil? 
      data["contact"]["company"] = data["event"]["company"]
      data["event"].delete("company")
     end
    end
    begin
    response = HTTParty.post(url+"/"+"track/post_data",
      :body => {:application_token => app_token,
              :action_type => action_type,
              :sdk => "ruby",
              :freshsales_data => data}.to_json,
      :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'}) 
     if response.code != 200
      raise Exceptions.new("Data not sent"),"Data is not sent to Freshsales because of the error code "+response.code.to_s
     end
    rescue Timeout::Error
       p "Could not post to #{url}: timeout"
    end   
  end

  def validate(params = {})
    if params.has_key?(:identifier) && params[:identifier].blank?
        raise Exceptions.new("Missing Email Parameter"),"Identifier(eg:Email) must be present!!!"
    elsif params.has_key?(:event_name) && params[:event_name].blank?
        raise Exceptions.new("Missing Event name Parameter"),"Event name must be present in trackEvent method!!!"
    elsif params.has_key?(:event_name)
        if ( !params.has_key?(:event_properties)) || (params.has_key?(:event_properties) &&  params[:event_properties].blank?) || (!params[:event_properties].has_key?("contact")) || (params[:event_properties].has_key?("contact") &&  params[:event_properties]["contact"].blank?) || (!params[:event_properties]["contact"].has_key?("Email")) || (params[:event_properties]["contact"].has_key?("Email") &&  params[:event_properties]["contact"]["Email"].blank?) 
          raise Exceptions.new("Missing contact Hash or Email parameter"),"Contact hash containing Email parameter should be present within eventproperties hash of trackEvent!!"
        else
          return true  
        end
    elsif params.has_key?(:post_page_view) && !params[:post_page_view]
        raise Exceptions.new("Post page view is not set"),"For page tracking to enable,you need to set post_page_view true"
    else        
      return true
    end
  end
 
end
