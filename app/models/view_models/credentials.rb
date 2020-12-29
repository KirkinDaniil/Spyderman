module ViewModel
  class Credentials
    attr_reader :full_name, :user_id, :photo_link

    def initialize (full_name, user_id, photo_link)
      @full_name = full_name
      @user_id = user_id
      @photo_link = photo_link
    end
  end
end
