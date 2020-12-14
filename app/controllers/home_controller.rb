class HomeController < ApplicationController

  def not_found
    render "404.html", status: :not_found
  end

  def index;  end

  #Showing search results as a 'card'
  def show
    @search = Search.find(params[:id])
  end

  #Initializing search process and creating db entrance
  def create
    @search = Search.new home_params
    if @search.vk_link == "" and @search.twi_link == ""
      return not_found
    end
    @vk = VkontakteApi::Client.new '5c4469995c4469995c446999b75c314cc355c445c44699903fac963479419a58644cb51'
    user = @vk.users.get(user_ids: @search.vk_link, fields:'photo_100', v:5.126)
    @search.vk_first_name = user.first.first_name
    @search.vk_last_name = user.first.last_name
    @search.vk_photo_link = user.first.photo_100
    twi_search = @search.twi_link.nil? ? @search.vk_link : @search.twi_link
    twi_user = parse_twitter(twi_search)
    if !twi_user.nil?
      @search.twi_full_name = twi_user.twi_full_name
      @search.twi_user_id = twi_user.twi_user_id
      @search.twi_photo_link = twi_user.twi_photo_link
    end

    @search.save
    redirect_to "/home/#{@search.id}"
  end

  private def home_params
    params.require(:search).permit(:vk_link, :inst_link, :twi_link)
  end

  #parsing twitter credentials
  private def parse_twitter(username)
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
    result = Twi.new(full_name, user_id, photo_link )
    return result
  end
end
