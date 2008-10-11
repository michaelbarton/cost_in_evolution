class << ActiveRecord::Base
  def each(chunk_size=1000)
    (0..self.last.id / chunk_size).each do |offset|
      self.find(:all,
        :limit => chunk_size,
        :conditions => ["id > ?", offset * chunk_size]).each do |i|
        yield i
      end
    end
  end
end
