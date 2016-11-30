module ActionComponent
  module Callbacks
    def self.prepended(base)
      base.class_attribute :before_render_callback_methods, :after_render_callback_methods

      base.before_render_callback_methods = []
      base.after_render_callback_methods = []

      base.extend ClassMethods
    end

    module ClassMethods
      def before_render(*methods)
        self.before_render_callback_methods += methods
      end

      def after_render(*methods)
        self.after_render_callback_methods += methods
      end
    end

    def render_view
      before_render_callback_methods.each { |method| send(method) }
      result = super
      after_render_callback_methods.each { |method| send(method) }
      result
    end
  end
end
