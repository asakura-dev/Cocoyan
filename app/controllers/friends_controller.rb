class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :friend_of_current_user, :only => [:show]
  def index
    ids = current_user.client.friend_ids(current_user.username)
    @friends = current_user.client.users(ids.take(21))
  end
  private
  #TODO
  def friend_of_current_user
    true
  end
end
