# frozen_string_literal: true

module Atm
  class WithdrawTransaction
    attr_reader :amount, :balance
    attr_accessor :cashed_notes, :notes, :total_cash_amount

    def initialize(balance:, amount:)
      @amount = amount
      @balance = balance
      @total_cash_amount = 0
      @cashed_notes = {}
    end

    def call
      cash_recalculation
      withdrawn_cash
    end

    private

    def cash_recalculation
      @notes = initialize_notes
    end

    def initialize_notes
      balance.default_balance.map { |n, c| Atm::Note.new(name: n.to_i, count: c) }
             .sort
    end

    def withdrawn_cash
      until total_cash_amount == amount
        current_note = fetch_notes

        balance.decrease!(current_note.to_s)
        balance.refresh!
      end
    end

    def fetch_notes
      notes.each do |note|
        current_note = note.value
        next if current_note > amount

        @total_cash_amount += current_note

        check_withdrawn_notes(current_note)

        break current_note
      end
    end

    def check_withdrawn_notes(note)
      if cashed_notes.key?(note)
        cashed_notes[note] += 1
      else
        cashed_notes[note] = 1
      end
    end
  end
end
