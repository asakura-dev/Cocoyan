class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :friend_of_current_user, :only => [:show]
  def index
    ids = current_user.client.friend_ids(current_user.username)
    @friends = current_user.client.users(ids.take(21))
  end

  def show
    @friend = Friend.find(params[:id])
    if @friend
      if @friend.status == "analyzed"
        #@events = @friend.events.take(10)
      end
    else
      @friend = Friend.new(username: params[:id])
      @friend.save
      #Thread.start do
      #  analyze(@friend)
      #end
    end
  end
  private
  #TODO
  def friend_of_current_user
    true
  end
end
