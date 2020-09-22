# frozen_string_literal: true

module Atm
  class Note
    include Comparable

    attr_reader :denomination, :count

    def initialize(denomination:, count:)
      @denomination = denomination
      @count = count
    end

    def <=>(other)
      if count < other.count
        -1
      elsif count == other.count
        denomination <=> other.denomination
      elsif count > other.count
        1
      end
    end
  end
end
