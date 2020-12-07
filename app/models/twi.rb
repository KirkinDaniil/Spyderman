class Twi
  attr_reader :twi_full_name, :twi_user_id, :twi_photo_link

  def initialize (full_name, user_id, photo_link)
  @twi_full_name = full_name
  @twi_user_id = user_id
  @twi_photo_link = photo_link
  end
end