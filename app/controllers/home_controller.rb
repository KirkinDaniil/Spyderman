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
    if @search.invalid?
      return not_found
    end
    #Insert VK credentials
    vk_search = @search.vk_link.nil? ? @search.twi_link : @search.vk_link
    vk_user = @search.get_vk vk_search
    if !vk_user.nil?
      @search.vk_first_name = vk_user.first.first_name
      @search.vk_last_name = vk_user.first.last_name
      @search.vk_photo_link = vk_user.first.photo_100
    end
    #Insert Twitter credentials
    twi_search = @search.twi_link.nil? ? @search.vk_link : @search.twi_link
    twi_user = @search.get_twitter(twi_search)
    if !twi_user.nil?
      @search.twi_full_name = twi_user.full_name
      @search.twi_user_id = twi_user.user_id
      @search.twi_photo_link = twi_user.photo_link
    end
    #insert Instagram credentials
    inst_search = @search.inst_link.nil? ? @search.vk_link : @search.inst_link
    inst_user = @search.get_inst inst_search
    if !inst_user.nil?
      @search.inst_fullname = inst_user.full_name
      @search.inst_photo_link = inst_user.photo_link
      @search.inst_user_id = inst_user.user_id
    end

    @search.save
    redirect_to "/home/#{@search.id}"
  end

  private def home_params
    params.require(:search).permit(:vk_link, :inst_link, :twi_link)
  end

end
