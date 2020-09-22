# frozen_string_literal: true

require_relative 'atm/evil_atm'

module Atm
  class Error < StandardError; end

  class AmountInvalid < Error; end
  class AmountTooLow < Error; end
  class AmountTooHigh < Error; end
end
