require "nokogiri"
require "open-uri"
require 'pry'

class PCDCalendar::Scraper

  def run
  end

  def self.scrape_calendar_page(url, current_month) # returns array of events with their event url's {name: , url: }
    html = open(url)
    doc = Nokogiri::HTML(html)
    events_hash_array = []
    event_hash = {}

    doc.css(".tribe-events-month-event-title").each do |event|
      event_hash = {
                name: event.text,
                url:  event.css("a").attr("href").value,
                month: current_month
              }
      events_hash_array << event_hash
    end

    events_hash_array
  end

  def self.scrape_events_from_event_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)
    event_hash = {}

    event_hash = {
                  name:    doc.css(".tribe-events-single-event-title").text.strip,
                  date:    doc.css("abbr").attr("title").value,
                  venue:   doc.css(".tribe-venue").text.strip,
                  address: doc.css("span .tribe-street-address").text.strip,
                  city:    doc.css("span .tribe-locality").text.strip,
                  state:   doc.css("span .tribe-region").text.strip,
                  zip:     doc.css("span .tribe-postal-code").text.strip,
                  group:   doc.css("p strong").text.strip
                  }

      if self.is_recurring?(doc) # selectors differ when events are recurring vs. non-recurring
        event_hash[:time] = doc.css(".tribe-recurring-event-time").text
      else
        event_time[:time] = doc.css(".tribe-events-start-time").text
      end

      if event_hash[:group] == ""
        event_hash[:group] = event_hash[:name].gsub(" Meeting!", "").gsub("Monthly", " ").gsub("Meeting", "").gsub("Combined","").strip
      end

      event_hash
  end # end self.scrape_events_from_event_page

  def self.scrape_group_from_event_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)
    group_hash = {}
    group_email = nil

    group_hash = {
                  name:  doc.css("p strong").text.strip,
                  phone: doc.css(".tribe-venue-tel").text.strip
                }

      if group_hash[:name] == ""
        group_hash[:name] = doc.css(".tribe-events-single-event-title").text.gsub(" Meeting!", "").gsub("Monthly", " ").gsub("Meeting", "").gsub("Combined","").strip
      end

      if group_hash[:phone] == "" && !doc.css(".tribe-organizer-tel").empty?
        group_hash[:phone] = doc.css(".tribe-organizer-tel").text.strip
      else
        doc.css(".tribe-events-single-event-description").text.split("\n").each do |line|
          if line.include?("Phone")
            group_hash[:phone] = line.split(":").last.strip
          end
        end
      end

      if !doc.css(".tribe-events-event-url").empty?
        group_hash[:url] = doc.css(".tribe-events-event-url").css("a").attr("href").value.strip
      elsif !doc.css(".tribe-events-single-event-description").css("a").empty?
        group_hash[:url] = doc.css(".tribe-events-single-event-description").css("a").attr("href").value.strip
      end

      if !doc.css(".tribe-organizer-email").empty?
        group_hash[:email] = doc.css(".tribe-organizer-email").text.strip
      else
        doc.css(".tribe-events-single-event-description").text.split("\n").each do |line|
          if line.include?("Email")
            group_hash[:email] = line.split(":").last.strip
          end
        end
      end
    group_hash
  end

end
