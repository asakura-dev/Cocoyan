class Friend < ActiveRecord::Base
  has_many :events,  -> { order 'count desc' }
  def to_param
    return username.parameterize
  end
  def self.find(key)
    return find_by_username(key)
  end
end
