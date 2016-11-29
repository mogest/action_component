require 'active_support/core_ext/module/delegation'

module ActionComponent
  RenderError = Class.new(StandardError)
  ConstraintError = Class.new(StandardError)
  ViewMissingError = Class.new(StandardError)

  class Base
    include ActionComponent::Constraints
    include ActionComponent::Elements

    delegate :concat, to: :@_view

    def self.render(view, opts = {})
      component = new(view, opts)
      component.load
      component.view
      nil
    end

    def initialize(view, opts = {})
      check_constraints!(opts)

      opts.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      @_view = view
    end

    def load
    end

    def view
      raise ActionComponent::ViewMissingError, "#{self.class.name} must define a view method to be a valid component"
    end

    private

    def method_missing(method, *args, &block)
      if @_view.respond_to?(method)
        @_view.send(method, *args, &block)
      else
        super
      end
    end

    def text(content)
      @_view.concat content
      nil
    end

    alias_method :text_node, :text
    alias_method :insert, :text

    def render(*args)
      @_view.concat(@_view.render(*args))
    end

    def component(component, opts = {})
      component.render(@_view, opts)
    end

    alias_method :render_component, :component
  end
end
