module Validator
  class Rut < Grape::Validations::Validator

    def validate_param!(attr_name, params)
      value = params[attr_name]
      if valid_rut? value
        true
      else
        throw :error, status: 401, message: "#{attr_name}: not a valid rut"
      end
    end

    def self.sanitize_rut(rut)
      rut, cv = rut.split('-')
      rut = rut.gsub('.', '').to_i
      [rut, cv]
    end

    def valid_rut?(rut)
      return false unless rut

      rut, cv = Rut::sanitize_rut rut

      return false unless rut and cv

      v = 1
      real_cv = 0
      for i in (2..9)
        if i == 8
          v = 2
        else
          v += 1
        end
        real_cv += v*(rut%10)
        rut /= 10
      end

      real_cv = 11 - real_cv%11
      if real_cv == 11
        real_cv = '0'
      elsif real_cv == 10
        real_cv = 'k'
      else
        real_cv = real_cv.to_s
      end
      real_cv == cv.downcase
    end
  end
end
