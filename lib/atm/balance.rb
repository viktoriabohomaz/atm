# frozen_string_literal: true

require 'json'

module Atm
  class Balance
    DEFAULT_BALANCE_FILE = './cash.json'
    attr_accessor :default_balance

    def initialize
      setup
    end

    def refresh!
      setup
    end

    def total
      @default_balance.map { |note, count| note.to_i * count }.reduce(:+)
    end

    def decrease!(note)
      default_balance[note] -= 1
      update!
    end

    private

    def setup
      @default_balance = read_balance_file
    end

    def read_balance_file
      cash_file = File.read(DEFAULT_BALANCE_FILE)
      JSON.parse(cash_file)
    end

    def update!
      File.open(DEFAULT_BALANCE_FILE, 'w') do |file|
        file.write(JSON.dump(default_balance))
      end
    end
  end
end
