require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module ActionComponent
  module Constraints
    extend ActiveSupport::Concern

    Constraint = Struct.new(:name, :class_constraint, :required?)

    included do
      class_attribute :initializer_constraints

      self.initializer_constraints = []
    end

    class_methods do
      def required(*fields)
        fields.each do |field|
          if field.is_a?(Hash)
            field.each do |name, class_constraint|
              self.initializer_constraints += [Constraint.new(name, class_constraint, true)]
            end
          else
            self.initializer_constraints += [Constraint.new(field, nil, true)]
          end
        end
      end

      def optional(fields)
        raise ActionComponent::ConstraintError, "optional can only take a hash of field names and classes" unless fields.is_a?(Hash)

        fields.each do |name, class_constraint|
          self.initializer_constraints += [Constraint.new(name, class_constraint, false)]
        end
      end
    end

    private

    def check_constraints!(opts)
      initializer_constraints.each do |constraint|
        if constraint.required? && !opts.member?(constraint.name)
          raise ActionComponent::ConstraintError, "#{constraint.name} is required for component #{self.class.name}"
        end

        if constraint.class_constraint && opts.member?(constraint.name) && !opts[constraint.name].is_a?(constraint.class_constraint)
          raise ActionComponent::ConstraintError, "#{constraint.name} must be a #{constraint.class_constraint.name}"
        end
      end
    end
  end
end
