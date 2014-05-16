class Employee < Sequel::Model
  plugin :validation_helpers
  plugin :timestamps, update_on_create: true

  raise_on_save_failure

  one_to_many :clocks

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

  end
end
