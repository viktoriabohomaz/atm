# frozen_string_literal: true
module Atm
  class Note
    include Comparable

    attr_accessor :name, :count

    def initialize(name:, count:)
      @name = name,
      @count = count
    end

    def <=>(other)
      if count < other.count
        1
      elsif count == other.count
        name <=> other.name
      elsif count > other.count
        -1
      end
    end
  end
end
