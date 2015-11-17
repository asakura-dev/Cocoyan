class Event < ActiveRecord::Base
  has_many :tweets, ->{order 'created_at desc'}
  def increment
    self.count = self.count + 1;
    self.save
  end
end
