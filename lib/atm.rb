# frozen_string_literal: true

module Atm
  class Error < StandardError; end

  class AmountInvalid < Error; end
  class AmountTooLow < Error; end
  class AmountTooHigh < Error; end
end
