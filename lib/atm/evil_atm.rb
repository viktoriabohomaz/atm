# frozen_string_literal: true

module Atm
  class EvilAtm
    attr_accessor :amount, :balance, :notes, :result

    def initialize(input = ::Input.call, balance = Atm::Balance.new)
      @amount = input
      @balance = balance
    end

    def withdraw_cash
      validate_input
      run_transaction
    end

    def print_result(result)
      result.each { |n, c| puts "Note: #{n}, Count: #{c}" }
    end

    private

    def validate_input
      unless (amount % 5).zero?
        raise AmountInvalid, 'The amount should be rounded to the nearest 5.'
      end
      if amount.negative?
        raise AmountInvalid, 'The amount should be greater than 0.'
      end

      total = balance.total
      return unless amount > total

      raise AmountTooHigh, "Please, input number less than #{total}."
    end

    def run_transaction
      transaction = WithdrawTransaction.new(balance: balance, amount: amount)
      transaction.call
      transaction.cashed_notes
    end
  end
end
