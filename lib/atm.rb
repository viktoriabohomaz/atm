# frozen_string_literal: true

require_relative 'atm/evil_atm'
require_relative 'atm/balance'
require_relative 'atm/note'
require_relative 'atm/withdraw_transaction.rb'
require_relative 'atm/version'

require_relative 'input'

module Atm
  class Error < StandardError; end

  class AmountInvalid < Error; end
  class AmountTooLow < Error; end
  class AmountTooHigh < Error; end
end


Atm::EvilAtm.new
