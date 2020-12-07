class HomeController < ApplicationController

  def index;  end

  #Showing search results as a 'card'
  def show
    @search = Search.find(params[:id])
  end

  #Initializing search process and creating db entrance
  def create
    @search = Search.new home_params
    @vk = VkontakteApi::Client.new '5c4469995c4469995c446999b75c314cc355c445c44699903fac963479419a58644cb51'
    user = @vk.users.get(user_ids: @search.vk_link, v:5.126)
    @search.vk_first_name = user.first.first_name
    @search.vk_last_name = user.first.last_name
    twi_search = @search.twi_link.nil? ? @search.vk_link : @search.twi_link
    twi_user = parse_twitter(twi_search)
    @search.twi_full_name = twi_user.twi_full_name
    @search.twi_user_id = twi_user.twi_user_id
    @search.twi_photo_link = twi_user.twi_photo_link
    @search.save
    redirect_to "/home/#{@search.id}"
  end

  private def home_params
    params.require(:search).permit(:vk_link, :inst_link, :twi_link)
  end

  #parsing twitter credentials
  private def parse_twitter(username)
    url = URI.parse("http://gettwitterid.com/?user_name=#{username}&submit=GET+USER+ID")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    #puts res.body
    doc = Nokogiri::HTML(res.body)
    full_name =  doc.xpath('/html/body/div/div[1]/table/tr[2]/td[2]/p').text.strip
    user_id = doc.xpath('/html/body/div/div[1]/table/tr[1]/td[2]/p').text.strip
    photo_link = doc.xpath('/html/body/div/div[1]/div/img/@src')
    result = Twi.new(full_name, user_id, photo_link )
    return result
  end
end
