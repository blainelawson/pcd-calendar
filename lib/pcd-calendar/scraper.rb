require "nokogiri"
require "open-uri"
require 'pry'

class PCDCalendar::Scraper

  def run
  end

  def self.scrape_calendar_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)
    events_hash_array = []
    event_hash = {}

    doc.css(".tribe-events-month-event-title").each do |event|
      event_hash = {
                name: event.text,
                url:  event.css("a").attr("href").value
              }
      # binding.pry
      events_hash_array << event_hash
      # binding.pry
      # self.scrape_event_page(event_url)
    end
    binding.pry
  end

  def self.scrape_event_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)
    event_hash = {}
    group_hash = {}
    group_email = nil
    # binding.pry



    event_hash = {
                  title:   doc.css(".tribe-events-single-event-title").text.strip,
                  date:    doc.css("abbr").attr("title").value,
                  venue:   doc.css(".tribe-venue").text.strip,
                  address: doc.css("span .tribe-street-address").text.strip,
                  city:    doc.css("span .tribe-locality").text.strip,
                  state:   doc.css("span .tribe-region").text.strip,
                  zip:     doc.css("span .tribe-postal-code").text.strip
                  }

      if self.is_recurring?(doc) # selectors differ when events are recurring vs. non-recurring
        event_hash[:time] = doc.css(".tribe-recurring-event-time").text
      else
        event_time[:time] = doc.css(".tribe-events-start-time").text
      end
    #^^^^^^ end event_hash creation

    group_hash = {
                  name:  doc.css("p strong").text.strip,
                  phone: doc.css(".tribe-venue-tel").text.strip
                }
      if doc.css(".tribe-events-single-event-description").css("a")
        group_hash[:page] = doc.css(".tribe-events-single-event-description").css("a").attr("href").value
      end

      doc.css(".tribe-events-single-event-description").text.split("\n").each do |line|
        if line.include?("Email")
          group_hash[:email] = line.split(":").last.strip
        end
      end
    #^^^^^^^ end group hash creation
    # binding.pry
  end # end self.scrape_event_page

  def self.is_recurring?(doc)
    doc.css("div .recurringinfo").text ? true : false
  end

end
