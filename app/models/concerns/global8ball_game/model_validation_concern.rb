# Concern to facilitate validations for Ohm-models
#
# Includes Ohm::Validations
# Raises an error describing what went wrong, if model is not valid
#
# All you have to do in models including this concern is to create a protected method called validate
# containing the assertations about your model. For available assertations see:
#
# https://github.com/soveran/scrivener
#
module Global8ballGame
  module ModelValidationConcern
    extend ActiveSupport::Concern
    include Ohm::Validations

    protected

    def after_validate
      handle_errors unless self.errors.empty?
    end

    def handle_errors
      mapped_errors = []

      self.errors.each do |key, value_array|
        mapped_errors << key.to_s + ' is ' + value_array.map{|v| v.to_s.humanize(capitalize: false)}.join(", ")
      end

      raise "#{self.class} is not valid. Errors: #{mapped_errors.join('. ')}."
    end
  end
end
