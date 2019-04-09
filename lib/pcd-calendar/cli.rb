# Our CLI Controller

class PCDCalendar::CLI
  BASE_PATH = 'https://pinellasdemocrats.org/events/2019-'
  MONTHS = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

  attr_accessor :current_month

    def call
      system 'clear'
      @current_month = main_menu
      make_events
      add_event_details
      make_groups_from_events
      display_events
    end

    def sub_menu_group_info
      input = nil
      PCDCalendar::Group.all.each.with_index(1) {|group, i| print "|  #{i}. #{group.name}  "}
      puts "|"
      puts
      puts "Enter group number for more info on group:"
      print "(Enter \"back\" to go back to events, \"exit\" to exit program, or \"restart\" to select a different month): "
      input = gets.strip
      if input == "back"
        system 'clear'
        display_events
      elsif input == "exit"
        system 'clear'
        quit
      elsif input == "restart"
        restart
      elsif !(1..PCDCalendar::Group.all.size).include?(input.to_i)
        sub_menu_group_info
      else
        display_group_info(input)
      end
    end

    def display_group_info(input)
      system 'clear'
      if input == "back"
        sub_menu_group_info
      else
        index = input.to_i - 1
        puts "=================================================================="
        puts "Group name: #{PCDCalendar::Group.all[index].name}"
        puts "Phone:      #{PCDCalendar::Group.all[index].phone}"
        puts "E-mail:     #{PCDCalendar::Group.all[index].email}"
        puts "URL:        #{PCDCalendar::Group.all[index].url}"
        puts "=================================================================="
        puts
      end
      sub_menu_group_info
    end


    def make_events
      puts "....Loading events! This will take a moment...."
      events_array = PCDCalendar::Scraper.scrape_calendar_page(BASE_PATH + @current_month)
      PCDCalendar::Event.create_from_collection(events_array)
    end

    def add_event_details
      PCDCalendar::Event.all.each do |event|
        details = PCDCalendar::Scraper.scrape_events_from_event_page(event.url)
        event.add_event_details(details)
      end
    end

    def make_groups_from_events
      PCDCalendar::Event.all.each do |event|
        group_hash = PCDCalendar::Scraper.scrape_group_from_event_page(event.url)
        event.group = PCDCalendar::Group.create_from_collection(group_hash)
      end
    end

    def print_months
      MONTHS.each.with_index(1) do |month, i|
        puts "#{i}. #{month}"
      end
    end

    def main_menu
      input = nil

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

      month
    end # main_menu

    def display_events
      system 'clear'
      # binding.pry
      puts "Displaying #{MONTHS[@current_month.to_i - 1]}"
      puts "*-*-*-*-*-*-*-*-*-*-*"

      puts "Events by group:"
      PCDCalendar::Group.all.each.with_index(1) do |group, i|
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
      sub_menu_group_info
    end

    def restart
      PCDCalendar::Group.reset!
      PCDCalendar::Event.reset!
      call
    end

    def quit
      puts "Goodbye"
    end
end
