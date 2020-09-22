# frozen_string_literal: true

require 'atm/version'
require 'byebug'

module Atm
  class EvilAtm
    attr_accessor :amount, :balance, :notes, :result

    def initialize(input = Input.call, balance = Atm::Balance.new)
      @amount = input
      @balance = balance
    end

    def withdraw_cash
      validate_input
      run_transaction
    end

    private

    def validate_input
      unless (amount % 5).zero?
        raise AmountInvalid, 'Amount should be rounded to the nearest 5.'
      end
      raise AmountTooLow, 'Amount too low.' if amount.negative?

      total = balance.total
      if amount > total
        raise AmountTooHigh, "Please input number less then #{total}"
      end
    end

    def run_transaction
      transaction = WithdrawTransaction.new(balance: balance, amount: amount)
      transaction.call
      transaction.cashed_notes
    end
  end
end
