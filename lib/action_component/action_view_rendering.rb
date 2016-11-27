module ActionComponent
  module ActionViewRendering
    def render_component(component_class, opts = {})
      component_class.render(self, opts)
    end
  end
end
