# frozen_string_literal: true

class Oystercard
  attr_reader :balance
  attr_reader :journey_history

  TOP_UP_MAX = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
    @journey_history = []
  end

  def top_up(top_up_value)
    raise "Balance exceeds #{TOP_UP_MAX}" if \
      @balance + top_up_value > TOP_UP_MAX

    @balance += top_up_value
  end

  def in_journey?
    return false if @journey_history.empty?
    !@journey_history.last.include?(:exit_station)
  end

  def touch_in(station)
    raise 'Insufficient funds' if @balance < MINIMUM_BALANCE
    journey_history << { :entry_station => station }
  end

  def touch_out(station)
    deduct MINIMUM_BALANCE
    journey_history.last[:exit_station] = station
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
