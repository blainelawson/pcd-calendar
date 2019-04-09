class PCDCalendar::Group
  attr_accessor :name, :phone, :url, :email, :events
  @@all = []

  def initialize(events)
    @events = []
    events.each {|k,v| self.send(("#{k}="), v)}
    add_events_to_group
    @@all << self
  end

  def self.create_from_collection(event)
      if !@@all.include?(event[:name])
        PCDCalendar::Group.new(event)
      end
  end

  def add_events_to_group
    PCDCalendar::Event.all.each do |e|
      if e.group == self.name
        self.events << e
      end
    end
  end

  def self.all
    @@all
  end
end
