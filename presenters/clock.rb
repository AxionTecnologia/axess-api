module Presenter
  class Clock

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

    def date_in
      @clock.clock_in.strftime("%d/%m/%Y")
    end

    def clock_in
      time_format @clock.clock_in
    end

    def clock_out
      time_format @clock.clock_out
    end

    def total_hours
      @clock.total_hours
    end

    def time_format(time)
      time.strftime("%H:%M:%S") if time
    end

    private :time_format


  end
end
