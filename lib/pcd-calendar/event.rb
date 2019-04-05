class PCDCalendar::Event
  attr_accessor :name, :date, :venue, :address, :city, :state, :zip
  @@all = []

  def initialize(events)
    events.each {|k,v| self.send(("#{k}="), v)}
    @@all << self
  end

  def self.all
    @@all
  end

end
