class EventController < ApplicationController
  def show
    @text = params["word"]
    @friend = Friend.find(params["id"])
    @event = Event.where(friend_id: @friend.id, name: @text).first
    @photos = []
    @photos_url = []
    search(@text)["photos"]["photo"].each do |photo|
      @photos.push(flickr_source_url(photo))
      @photos_url.push(flickr_photo_url(photo))
    end
  end
end
private
def search(text)
  res = RestClient.get 'https://api.flickr.com/services/rest', {:params => {:method => 'flickr.photos.search', :api_key => ENV['FL_CONS_KEY'], :text => text, :format => 'json', :sort => 'relevance', :per_page => '10'}}
  res.slice!(0,14)
  res.slice!(-1,1)
  JSON.parse(res)
end

def flickr_source_url(p)
  "http://farm#{p['farm']}.staticflickr.com/#{p['server']}/#{p['id']}_#{p['secret']}.jpg"
end
def flickr_photo_url(p)
  "https://www.flickr.com/photos/#{p['owner']}/#{p['id']}"
end
