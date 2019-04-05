# Our CLI Controller

class PCDCalendar::CLI

  MONTHS = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    def call
      url = 'https://pinellasdemocrats.org/events/2019-05/'
      events_array = PCDCalendar::Scraper.scrape_calendar_page(url)
      make_events(events_array)
      binding.pry
      main_menu
    end

    def make_events(events_array)
      events_array.each do |event|
        # binding.pry
        event = PCDCalendar::Event.new(event)
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
