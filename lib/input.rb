# frozen_string_literal: true

class Input
  def self.call
    send_welcome
    fetch_input
  end

  def self.send_welcome
    puts "Welcome to the 'Ruby ATM' program\n
    To withdraw cash, please enter the number multiple of 5"
  end

  def self.fetch_input
    gets.chomp.to_i
  end
end
