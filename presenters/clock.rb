class ClockPresenter

  def initialize(clock)
    @clock = clock
  end

  def event
    return 'clock-out' if @clock.clock_out
    'clock-in'
  end

  def timestamp
    return @clock.clock_out if event == 'clock-out'
    @clock.clock_in
  end

end
