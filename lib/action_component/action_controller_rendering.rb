module ActionComponent
  module ActionControllerRendering
    private

    def render_component(component_class, opts = {})
      @_component_class = component_class
      @_component_options = opts

      render_opts = {
        inline: "<% render_component(@_component_class, @_component_options) %>",
        layout: true
      }

      [:content_type, :layout, :location, :status, :formats].each do |option|
        render_opts[option] = opts[option] if opts.member?(option)
      end

      render render_opts
    end
  end
end
