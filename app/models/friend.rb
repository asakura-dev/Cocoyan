class Friend < ActiveRecord::Base
  def to_param
    return username.parameterize
  end
  def self.find(key)
    return find_by_username(key)
  end
end
