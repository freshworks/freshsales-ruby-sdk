require 'freshsales/analytics/version'

module FreshsalesAnalytics

  @config = {
              app_token: nil,
              url: nil
            }

  @valid_config_keys = @config.keys

  class Exceptions < StandardError
    attr_reader :err_obj
    def initialize(err_obj)
      @err_obj = err_obj
    end
  end

  class << self
    def identify(identifier, visitor_properties = {})
      if validate(identifier: identifier, visitor_properties: visitor_properties)
        custom_data = {}
        custom_data[:identifier] = identifier
        custom_data[:visitor]  = visitor_properties
        post_data('visitors', custom_data)
      end   
    end

    def set(identifier, set_properties = {})
      if validate(identifier: identifier, set_properties: set_properties)
        custom_data = {}
        custom_data[:identifier] = identifier
        custom_data[:visitor] = set_properties
        post_data('visitors', custom_data)
      end
    end

    def trackEvent(identifier, event_name, event_properties = {})
      if validate(identifier: identifier, event_name: event_name, event_properties: event_properties)
        event_properties[:name] = event_name
        custom_data = {}
        custom_data[:identifier] = identifier
        custom_data[:event] = event_properties
        post_data('events', custom_data)
      end
    end

    def trackPageView(identifier, page_url)
      if validate(identifier: identifier, page_url: page_url)
        custom_data = {}
        custom_data[:identifier] = identifier
        custom_data[:page_view] = { url: page_url }
        post_data('page_views', custom_data)
      end
    end

    private

    def post_data(action, data)
      url, app_token = get_url_and_app_token
      request_body = data.merge({ application_token: app_token, sdk: 'ruby' }).to_json
      begin
        response = HTTParty.post(url + '/track/' + action,
                                body: request_body,
                                headers:  {
                                  'Content-Type' => 'application/json',
                                  'Accept' => 'application/json'}) 
        if response.code != 200
          raise Exceptions.new('Data not sent'),
            'Data is not sent to Freshsales because of the error code ' + response.code.to_s
        end
      rescue Timeout::Error
        p 'Could not post to #{url}: timeout'
      end
    end

    def get_url_and_app_token
      url = @config[:url]
      app_token = @config[:app_token]
      if url.nil? || app_token.nil?
        configure_with_yaml(File.join(Rails.root, 'config', 'fs_analytics_config.yml'))
        url = @config[:url]
        app_token = @config[:app_token]
      end
      [url, app_token]
    end

    def configure_with_yaml(path_to_yaml_file)
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        raise Exceptions.new, 'YAML configuration file could not be found.'
      rescue Psych::SyntaxError
        raise Exceptions.new, 'YAML configuration file contains invalid syntax.'
      end 
      configure(config)
    end

    def configure(opts = {})
      opts.each do |k, v|
        if @valid_config_keys.include? k.to_sym
          @config[k.to_sym] = v
        else
          raise Exceptions.new('Error in configuration'),
              k.to_s + ' is not present in the configuration settings keys list'
        end
      end  
    end

    def validate(params = {})
      if params.key?(:identifier) && params[:identifier].nil?
        raise Exceptions.new('Missing Email Parameter'),
           'Identifier(eg:Email) must be present!!!'
      elsif params.key?(:event_name) && params[:event_name].nil?
        raise Exceptions.new('Missing Event name Parameter'),
            'Event name must be present in trackEvent method!!!'
      elsif params.key?(:page_url) && params[:page_url].nil?
        raise Exceptions.new('No Page Url'),
            'Page url to track is not set!!!'
      elsif params.key?(:set_properties) &&  !params[:set_properties].any?
        raise Exceptions.new('Missing set properties'),
          'set properties are blank so,nothing to set!!!'
      else        
        return true
      end
    end

  end

end
