class Search < ActiveRecord::Base

  #checks params
  def invalid?
    vk_link == "" and twi_link == "" and inst_link == ""
  end

  #getting vk_info
  def get_vk(user_id)
    @vk = VkontakteApi::Client.new API_VK["token"]
    user = @vk.users.get(user_ids: user_id, fields:'photo_100', v:5.126)
  end

end