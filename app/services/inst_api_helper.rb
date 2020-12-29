class InstApiHelper

  def initialize
    super
  end

  def get_inst(username)
    url = URI("https://instagram30.p.rapidapi.com/rapi/user/#{username}?username=#{username}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = API_INST["token"]
    request["x-rapidapi-host"] = 'instagram30.p.rapidapi.com'

    response = http.request(request)
    hash = JSON.parse response.read_body
    if hash.empty?
      return nil
    end
    full_name = hash["fullname"]
    photo_link = hash["profilePicUrl"]
    user_id = hash["id"]
    result = ViewModel::Credentials.new full_name, user_id, photo_link
    return result
  end
end