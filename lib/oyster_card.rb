# frozen_string_literal: true
require_relative 'journey'

class Oystercard
  attr_reader :balance
  attr_reader :journey_history
  attr_reader :current_journey

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
    !!@current_journey
  end

  def touch_in(station)
    raise 'Insufficient funds' if @balance < MINIMUM_BALANCE
    if in_journey?
      @journey_history << @current_journey
    end
      @current_journey = Journey.new
      @current_journey.start_journey(station)
  end

  def touch_out(station)

    if !in_journey?
      @current_journey = Journey.new
    end
    @current_journey.end_journey(station)
    @journey_history << @current_journey
    deduct @current_journey.fare
    @current_journey = nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
