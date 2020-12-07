class HomeController < ApplicationController

  def index;  end

  def show

    @search = Search.find(params[:id])

  end

  def create

    @search = Search.new home_params
    @vk = VkontakteApi::Client.new '5c4469995c4469995c446999b75c314cc355c445c44699903fac963479419a58644cb51'
    user = @vk.users.get(user_ids: @search.vk_link, v:5.126)
    @search.victim_bio = user.first.first_name + user.first.last_name
    @search.save
    parse_twitter(@search.vk_link)
    redirect_to "/home/#{@search.id}"

  end

  private def home_params
    params.require(:search).permit(:vk_link, :inst_link, :twi_link)
  end

  private def parse_twitter(username)
    url = URI.parse("http://gettwitterid.com/?user_name=#{username}&submit=GET+USER+ID")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body
  end
end
