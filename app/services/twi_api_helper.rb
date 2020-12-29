class Twi_api_helper
  #getting twitter credentials
  def get_twitter(username)
    url = URI("https://peerreach-peerreach-subscription.p.rapidapi.com/user/lookup.json?screen_name=#{username}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = API_TWI["token"]
    request["x-rapidapi-host"] = 'peerreach-peerreach-subscription.p.rapidapi.com'

    response = http.request(request)
    hash = JSON.parse response.read_body
    if hash.empty?
      return nil
    end
    full_name = username
    user_id = hash['user_id']
    photo_link = "https://twitter.com/#{username}/photo"
    result = Credentials.new(full_name, user_id, photo_link )
    return result
    end
end