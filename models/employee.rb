class Employee < Sequel::Model
  plugin :validation_helpers
  plugin :timestamps, update_on_create: true

  raise_on_save_failure

  one_to_many :clocks, order: :clock_in

  def validate
    super
    validates_unique [:rut]
  end

  dataset_module do

    def by_active
      where(active: true)
    end

    def by_rut(rut)
      where(rut: rut).first
    end

    def monthly_data(opts)
      eager_graph(:clocks).
      where{Sequel.&(
        clocks__clock_in.extract(:month) => opts[:month],
        clocks__clock_in.extract(:year) => opts[:year]
      )}

    end

    def monthly_data_by_employee(opts)
      monthly_data(opts).where(employee_id: opts[:employee_id]).all.first
    end

  end
end
