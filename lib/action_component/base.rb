require 'active_support/core_ext/module/delegation'

module ActionComponent
  RenderError = Class.new(StandardError)
  ConstraintError = Class.new(StandardError)
  ViewMissingError = Class.new(StandardError)

  class Base
    include ActionComponent::Constraints
    include ActionComponent::Elements
    prepend ActionComponent::Callbacks

    delegate :concat, to: :@_view

    def self.render(view, opts = {})
      component = new(view, opts)
      component.load
      component.render_view
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

    def render_view
      view
    end

    private

    def method_missing(method, *args, **kwargs, &block)
      if @_view.respond_to?(method)
        @_view.send(method, *args, **kwargs, &block)
      else
        super
      end
    end

    def text(content = nil, &block)
      @_view.concat content if content
      @_view.concat block.call if block
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

    def form_for(*args, &block)
      text @_view.form_for(*args, &block)
    end

    def form_tag(*args, &block)
      text @_view.form_tag(*args, &block)
    end
  end
end
