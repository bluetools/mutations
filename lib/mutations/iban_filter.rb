require 'iban-tools'

module Mutations
  class IBANFilter < InputFilter
    @default_options = {
      :nils => false,       # true allows an explicit nil to be valid. Overrides any other options
      :empty => false,      # true allows the value to be empty
      :canonical => true    # true canonizes IBAN to make it suitable for saving and comparing
    }

    def filter(data)
      # Handle nil case
      if data.nil?
        return [nil, nil] if options[:nils]
        return [nil, :nils]
      end

      # Check if data is a String
      if data.is_a?(String)
        # Check if data is empty
        if data == ""
          if options[:empty]
            return [data, nil]
          else
            return [data, :empty]
          end
        else
          # Check if data is valid IBAN
          iban = IBANTools::IBAN.new(data)
          if not iban.validation_errors.empty?
            return [data, :iban]
          end
        end
      else
        return [nil, :iban]
      end

      # canonize IBAN
      data = iban.code if options[:canonical]

      # We win, it's valid!
      [data, nil]
    end
  end
end
