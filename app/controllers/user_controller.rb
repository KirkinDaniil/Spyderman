class UserController < ApplicationController

  before_action :authenticate_user!
  def index
    @search = Search.where user_id: current_user.id
  end

end