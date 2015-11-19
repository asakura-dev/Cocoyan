# coding: utf-8
class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :friend_of_current_user, :only => [:show]
  def index
    ids = current_user.client.friend_ids(current_user.username)
    @friends = current_user.client.users(ids.take(40))
  end

  def show
    @friend = Friend.find(params[:id])
    
    if @friend
      if @friend.status == "analyzed"
        @events = @friend.events.take(10)
      end
    else
      @friend = Friend.new(username: params[:id])
      @friend.save
      AnalyzeJobJob.perform_later(@friend.id,current_user.id)
    end
  end
  private
  def analyze(friend,current_user)
    friend_id = friend.id
    nm = Natto::MeCab.new
    tweets = current_user.client.user_timeline(friend.username, {count: 200})
    tweets.each do |tweet|
      nm.parse(tweet.full_text){|word|
        if word.feature.split(',')[0] == "名詞" &&
           EventDictionary.where(text: word.surface).first
          if event = Event.where(friend_id: friend_id, name: word.surface).first
            event.increment
            t = Tweet.new(event_id: event.id, text: tweet.full_text, url: tweet.uri, time: tweet.created_at)
            t.save
          else
            event = Event.new(friend_id: friend_id, name: word.surface, count: 1)
            event.save
            t = Tweet.new(event_id: event.id, text: tweet.full_text, url: tweet.uri, time: tweet.created_at)
            t.save
          end
        end
      }
    end
    @events = friend.events.take(10)
    @events.each do |event|
      unless event.image_url
        image_url = flickr_url(search(event.name)["photos"]["photo"][0])
        event.image_url = image_url
        event.save
      end
    end
    friend.status = "analyzed"
    friend.save
  end
  def search(text)
    res = RestClient.get 'https://api.flickr.com/services/rest', {:params => {:method => 'flickr.photos.search', :api_key => ENV['FL_CONS_KEY'], :text => text, :format => 'json', :sort => 'relevance', :per_page => '10'}}
    res.slice!(0,14)
    res.slice!(-1,1)
    JSON.parse(res)
  end
  def flickr_url(p)
    "http://farm#{p['farm']}.staticflickr.com/#{p['server']}/#{p['id']}_#{p['secret']}.jpg"
  end
  def friend_of_current_user
    true
  end
end
