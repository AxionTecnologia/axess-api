class Clock < Sequel::Model
  many_to_one :employee
  plugin :timestamps, update_on_create: true

  dataset_module do

    def tick(employee_id)
      clock = where(employee_id: employee_id, clock_out: nil).first
      if clock and not clock.clock_out
        clock.clock_out = DateTime.now
        clock.total_hours = (clock.clock_out - clock.clock_in)/3600
        clock.save
      else
        options = { employee_id: employee_id, clock_in: DateTime.now }
        clock = Clock.create(options)
      end
      clock
    end

  end

end
