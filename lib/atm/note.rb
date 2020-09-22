# frozen_string_literal: true

class Atm::Note
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

  def to_hash
    { instance_variable_get('@name').first => instance_variable_get('@count') }
  end

  alias to_h to_hash
end
