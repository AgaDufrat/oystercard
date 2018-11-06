# frozen_string_literal: true

class Oystercard
  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(top_up_value)
    @balance += top_up_value
  end
end