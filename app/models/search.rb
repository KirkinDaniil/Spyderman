class Search < ActiveRecord::Base

  #checks params
  def invalid?
    vk_link == "" and twi_link == "" and inst_link == ""
  end

  #getting vk_info
  def get_vk(user_id)
    @vk = VkontakteApi::Client.new '5c4469995c4469995c446999b75c314cc355c445c44699903fac963479419a58644cb51'
    user = @vk.users.get(user_ids: user_id, fields:'photo_100', v:5.126)
  end

  #getting inst info
  def get_inst(username)
    url = URI("https://instagram30.p.rapidapi.com/rapi/user/#{username}?username=#{username}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = '6a8006dfc8msh9d6af52ac22eaf1p1350dcjsn07c12c474009'
    request["x-rapidapi-host"] = 'instagram30.p.rapidapi.com'

    response = http.request(request)
    hash = JSON.parse response.read_body
    if hash.empty?
      return nil
    end
    puts hash
    full_name = hash["fullname"]
    photo_link = hash["profilePicUrl"]
    user_id = hash["id"]
    puts full_name, user_id
    result = Credentials.new(full_name, user_id, photo_link)
    return result
  end

  #getting twitter credentials
  def get_twitter(username)
    url = URI("https://peerreach-peerreach-subscription.p.rapidapi.com/user/lookup.json?screen_name=#{username}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = '6a8006dfc8msh9d6af52ac22eaf1p1350dcjsn07c12c474009'
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