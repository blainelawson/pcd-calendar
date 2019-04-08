# Our CLI Controller

class PCDCalendar::CLI

  MONTHS = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    def call
      make_events
      make_groups_from_events
      add_event_details
      main_menu
    end

    def make_events
      url = 'https://pinellasdemocrats.org/events/2019-05/'
      events_array = PCDCalendar::Scraper.scrape_calendar_page(url)
      PCDCalendar::Event.create_from_collection(events_array)
    end

    def add_event_details
      PCDCalendar::Event.all.each do |event|
        # binding.pry
        details = PCDCalendar::Scraper.scrape_events_from_event_page(event.url)
        event.add_event_details(details)
      end
    end

    def make_groups_from_events
      PCDCalendar::Event.all.each do |event|
        # binding.pry
        group_hash = PCDCalendar::Scraper.scrape_group_from_event_page(event.url)
        event.group = PCDCalendar::Group.create_from_collection(group_hash)
        # binding.pry

      end
    end

    def print_months
      MONTHS.each.with_index(1) do |month, i|
        puts "#{i}. #{month}"
      end
    end

    def main_menu
      input = nil

      while input != "exit"
        puts "What month would you like to view events?"
        puts "(type \"exit\" to exit program)"
        puts "Enter number or month:"
        print_months

        input = gets.strip

        if (1..12).include?(input.to_i) || MONTHS.include?(input)
          MONTHS.include?(input) ? month = MONTHS.index(input) : month = input
        end

        system 'clear'
        puts "Displaying #{MONTHS[month.to_i - 1]}"
        puts "*-*-*-*-*-*-*-*-*-*-*"
        puts "display_events(month)"
      end
    end # main_menu

    def display_events(month)
      scraper
    end
end
