# frozen_string_literal: true

class Oystercard
  attr_reader :balance
  attr_reader :entry_station

  TOP_UP_MAX = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(top_up_value)
    raise "Balance exceeds #{TOP_UP_MAX}" if \
      @balance + top_up_value > TOP_UP_MAX

    @balance += top_up_value
  end

  def in_journey?
    @in_use
  end

  def touch_in(station)
    raise 'Insufficient funds' if @balance < MINIMUM_BALANCE
    @in_use = true
    @entry_station = station
  end

  def touch_out
    @in_use = false
    deduct MINIMUM_BALANCE
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
