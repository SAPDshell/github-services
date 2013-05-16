class Service::SAPDshell < Service
  string   :dshell_url, :user_id
  password :password
  white_list :space_id, :user_id


  url "http://dshell.saphana.com"
  logo_url "http://www.sap.com/global/ui/images/global/sap-logo.png"

  # SAPDshell on GitHub is pinged for any bugs with the Hook code.
  maintained_by :github => 'SAPDshell'

  # Support channels for user-level Hook problems (service failure,
  # misconfigured
  supported_by :web => 'http://scn.sap.com/community/developer-center/content',
               :email => 'dshell@sap.com'
        

  def receive_push
    
    # Check for settings
    if data['dshell_url'].to_s.empty?
      raise_config_error "SAP Dshell URL not set"
    end
    if data['user_id'].to_s.empty?
      raise_config_error "User id not set"
    end
    if data['password'].to_s.empty?
      raise_config_error "Password not set"
    end
    
    # Sets this basic auth info for every request.
    http.basic_auth(data['user_id'], data['password'])
    
    # http.headers['Content-Type'] = 'application/json'
    
    # Uses this URL as a prefix for every request.
    http.url_prefix = "http://"
    
    
    repository = payload['repository']['url'].to_s
    dshell_url = data['dshell_url']
    
    call_url =  "{dshell_url}/?repo={repository}"
      
    res = http_post call_url 

    if res.status < 200 || res.status > 299
      raise_config_error "Failed with #{res.status}"
    end

  rescue URI::InvalidURIError
    raise_config_error "Invalid URL: #{call_url}"
    
    
  
end