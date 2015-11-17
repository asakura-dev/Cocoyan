class EventController < ApplicationController
  def show
    @text = params["word"]
    @friend = Friend.find(params["id"])
    @event = Event.where(["friend_id = ? and name = ?", @friend.id, @text])
    @photos = []
    search(@text)["photos"]["photo"].each do |photo|
      @photos.push(flickr_url(photo))
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

def flickr_url(p)
  "http://farm#{p['farm']}.staticflickr.com/#{p['server']}/#{p['id']}_#{p['secret']}.jpg"
end
