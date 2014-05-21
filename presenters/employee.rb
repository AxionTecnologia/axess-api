module Presenter
  class Employee

    def initialize(employee)
      @employee = employee
    end

    def id
      @employee.id
    end

    def rut
      with_thousand_sep = @employee.rut.to_s.gsub(/(\d)(?=\d{3}+$)/, '\1.')
      "#{with_thousand_sep}-#{@employee.cv}"
    end

    def name
      @employee.name
    end

    def last_name
      @employee.last_name
    end

    def full_name
      "#{name} #{last_name}"
    end

    def active
      @employee.active
    end

  end
end
