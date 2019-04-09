# Our CLI Controller

class PCDCalendar::CLI
  BASE_PATH = 'https://pinellasdemocrats.org/events/2019-'
  MONTHS = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    def call
      month = main_menu
      make_events(month)
      add_event_details
      make_groups_from_events
      display_events

    end

    def make_events(month)
      events_array = PCDCalendar::Scraper.scrape_calendar_page(BASE_PATH + month)
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

      # while input != "exit"
        puts "What month would you like to view events?"
        puts "(type \"exit\" to exit program)"
        puts "Enter number or month:"
        print_months

        input = gets.strip

        if (1..12).include?(input.to_i) || MONTHS.include?(input)
          MONTHS.include?(input) ? month = MONTHS.index(input) : month = input
          if month.size < 2
            month = "0" + month
          end
        end
        # binding.pry
        system 'clear'
        puts "Displaying #{MONTHS[month.to_i - 1]}"
        puts "*-*-*-*-*-*-*-*-*-*-*"

      month

      # end
    end # main_menu

    def display_events
      # binding.pry
      puts "Events by group:"
      PCDCalendar::Group.all.each.with_index(1) do |group, i|
        # binding.pry
        puts "#{i}. #{group.name}"
        puts "==============================================="
        group.events.each do |event|
          puts event.name
          puts "#{event.date}, #{event.time}"
          puts event.venue
          puts event.address
          puts "#{event.city}, #{event.state} #{event.zip}"
          puts "-----------------------------------------------"
        end
        puts
      end
    end
end
