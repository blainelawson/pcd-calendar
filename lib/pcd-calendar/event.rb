class PCDCalendar::Event
  attr_accessor :name, :date, :time, :venue, :address, :city, :state, :zip, :url, :group, :month

  # either using the date, OR add a month attrubute#
  # make sure we don't scrape for the same month's events mor than one
  # add a method, a class method called `.find_by_month` which should take a mongth as an argunemnt
  # and return all events scheduled for rthat month... this could be used to deteremined if a particular has been scraped
  @@all = []

  def initialize(events)
    events.each {|k,v| self.send(("#{k}="), v)}
    @@all << self
  end

  def self.find_by_month(month)
    self.all.select do |event|
      event.month == month
    end
  end

  def self.all
    @@all
  end

  def add_event_details(details)
    details.each do |k,v|
      self.send(("#{k}="), v)
    end
  end

  def self.create_from_collection(events_array)
    events_array.each do |event|
      PCDCalendar::Event.new(event)
    end
  end

  def self.reset!
    @@all.clear
  end
end
