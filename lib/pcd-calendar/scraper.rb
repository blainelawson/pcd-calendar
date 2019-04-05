require "nokogiri"
require "open-uri"
require 'pry'

class PCDCalendar::Scraper

  def run
  end

  def self.scrape_calendar_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)

    doc.css(".tribe-events-month-event-title").each do |event|
      event_url = event.css("a").attr("href").value
      self.scrape_event_page(event_url)
    end
  end

  def self.scrape_event_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)
    binding.pry

    event_title = doc.css(".tribe-events-single-event-title").text
    group_type = doc.css("p strong").text
    event_date_and_time = doc.css("h2 .tribe-event-date-start").text + " - " + doc.css("h2 .tribe-event-time").text
  end
end
