# frozen_string_literal: true

module Atm
  class WithdrawTransaction
    attr_reader :amount, :balance
    attr_accessor :cashed_notes, :notes, :total_cash_amount, :residual_amount

    def initialize(balance:, amount:)
      @amount = amount
      @balance = balance
      @total_cash_amount = 0
      @cashed_notes = {}
      @residual_amount = amount
    end

    def call
      cash_recalculation
      withdrawn_cash
    end

    private

    def initialize_notes
      balance.default_balance.map do |note, count|
        Atm::Note.new(denomination: note.to_i, count: count) if count.positive?
      end.compact.sort.reverse
    end

    def cash_recalculation
      @notes = initialize_notes
    end

    def withdrawn_cash
      until total_cash_amount.eql?(amount)
        cash_recalculation
        validate_amount

        current_note = take_cash.to_s

        balance.decrease!(current_note)
        balance.refresh!
      end
    end

    def validate_amount
      return unless amount_less_than_min_note?

      raise AmountTooLow, 'There are no suitable banknotes in ATM.'
    end

    def amount_less_than_min_note?
      residual_amount < notes.min_by(&:denomination).denomination
    end

    def take_cash
      notes.each do |note|
        current_note = note.denomination
        next if current_note > residual_amount || note.count <= 0

        @total_cash_amount += current_note
        @residual_amount -= current_note

        collect_withdrawn_cash(current_note)

        return current_note
      end
    end

    def collect_withdrawn_cash(note)
      return cashed_notes[note] += 1 if cashed_notes.key?(note)

      cashed_notes[note] = 1
    end
  end
end
