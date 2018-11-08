class Journey

  attr_reader :exit_station, :entry_station

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def start_journey(entry_station)
    @entry_station = entry_station
  end

  def end_journey(exit_station)
    @exit_station = exit_station
  end

  def fare
    return MINIMUM_FARE if complete_journey?
    PENALTY_FARE
  end

  def complete_journey?
    @entry_station && @exit_station
  end
end
