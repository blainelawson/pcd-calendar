class PCDCalendar::Event
  attr_accessor :name, :date, :time, :venue, :address, :city, :state, :zip, :url, :group
  @@all = []

  def initialize(events)
    events.each {|k,v| self.send(("#{k}="), v)}
    @@all << self
  end

  def self.all
    @@all
  end

  def add_event_details(details)
    # binding.pry
    details.each do |k,v|
      self.send(("#{k}="), v)
      # binding.pry
    end
    binding.pry
  end

  def self.create_from_collection(events_array)
    events_array.each do |event|
      PCDCalendar::Event.new(event)
    end
  end
end
