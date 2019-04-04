# Our CLI Controller

class PCDCalendar::CLI

  MONTHS = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    def call
      main_menu
    end

    def main_menu
      input = nil

      while input != "exit"
        puts "What month would you like to view events?"
        puts "(type \"exit\" to exit program)"
        puts "Enter number or month:"
        MONTHS.each.with_index(1) do |month, i|
          puts "#{i}. #{month}"
        end

        input = gets.strip

        if (1..12).include?(input.to_i) || MONTHS.include?(input)
          MONTHS.include?(input) ? month = MONTH.index(input) : month = input
        end

          case input
          when "quick view"
            upcoming_events
          when "1"


end
