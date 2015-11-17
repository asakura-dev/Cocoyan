require './lib/batch/db.rb'
class Batch::InitEventDic
  def self.run
    EventDictionary.delete_all()
    $words.each do |word|
      @w = EventDictionary.new(text: word["word"], count: word["count"])
      @w.save
    end
  end
  def self.show
    EventDictionary.all.each_with_index do |w, i|
      puts w.id
      puts w.text
      if i == 100
        break
      end
    end
  end
end
