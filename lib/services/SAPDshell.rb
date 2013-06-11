class Service::SAPDshell < Service::HttpPost
  string   :dshell_url, :user_id
  password :password


  url "http://dshell.saphana.com"
  logo_url "http://www.sap.com/global/ui/images/global/sap-logo.png"

  # SAPDshell on GitHub is pinged for any bugs with the Hook code.
  maintained_by :github => 'SAPDshell'

  # Support channels for user-level Hook problems (service failure,
  # misconfigured
  supported_by :web => 'http://scn.sap.com/community/developer-center/content',
               :email => 'dshell@sap.com'
        

  def receive_event
    
    # Check for settings
    if  required_config_value('dshell_url').to_s.empty?
      raise_config_error "SAP Dshell URL not set"
    end
    if  required_config_value('user_id').to_s.empty?
      raise_config_error "User id not set"
    end
    if  required_config_value('password').to_s.empty?
      raise_config_error "Password not set"
    end
    
    # Sets this basic auth info for every request.
    http.basic_auth( required_config_value('user_id'),  required_config_value('password'))
    
    http.headers['Content-Type'] = 'application/json'
    
    # Uses this URL as a prefix for every request.
    http.url_prefix = "http://"
    
    
    l_repository = payload['repository']['url'].to_s
    l_dshell_url =  required_config_value('dshell_url')
    
    l_call_url =  "#{l_dshell_url}/?repo=#{l_repository}"
     
    res = deliver l_call_url
    

    if res.status < 200 || res.status > 299
      raise_config_error "Failed with #{res.status}"
    end

  rescue URI::InvalidURIError
    raise_config_error "Invalid URL: #{l_call_url}"
    
    
end
end
