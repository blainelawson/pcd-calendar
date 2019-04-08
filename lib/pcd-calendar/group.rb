class PCDCalendar::Group
  attr_accessor :name, :phone, :url, :email, :events
  @@all = []

  # def initialize(events)
  #   events.each {|k,v| self.send(("#{k}="), v)}
  #   @@all << self
  # end

  def self.all
    @@all
  end
end
