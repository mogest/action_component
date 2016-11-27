module ActionComponent
  RenderError = Class.new(StandardError)

  ELEMENTS = %w(
    html head title base link meta style
    script noscript
    body section nav article aside h1 h2 h3 h4 h5 h6 hgroup header footer address
    p hr br pre blockquote ol ul li dl dt dd figure figcaption div
    a em strong small s cite q dfn abbr time code var samp kbd sub sup i b u mark rt rp bdi bdo span
    ins del
    img iframe embed object param video audio source track canvas map area
    table caption colgroup col tbody thead tfoot tr td th
    form fieldset legend label input button select datalist optgroup option textarea keygen output progress meter
    details summary command menu
  )

  class Base
    delegate :concat, to: :@_view

    def self.define_tags(*element_names)
      element_names.each do |element_name|
        define_method(element_name) do |*args, &block|
          element(element_name, *args, &block)
        end

        private element_name
      end
    end

    define_tags *ActionComponent::ELEMENTS

    def self.render(view, opts = {})
      component = new(view, opts)
      component.load
      component.view
    end

    def initialize(view, opts = {})
      opts.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      @_view = view
    end

    def load
    end

    def view
      raise "#{self.class.name} must define a view method to be a valid component"
    end

    private

    def method_missing(method, *args, &block)
      if @_view.respond_to?(method)
        @_view.send(method, *args, &block)
      else
        super
      end
    end

    def render(*args)
      @_view.concat(@_view.render(*args))
    end

    def render_component(component, opts = {})
      self.class.render(@_view, opts)
    end

    def text(content)
      @_view.concat content
    end

    alias_method :text_node, :text
    alias_method :insert, :text

    def doctype(text = "html")
      @_view.concat("<!doctype #{h(text)}>".html_safe)
    end

    def element(name, first = nil, second = nil, &block)
      if first.is_a?(Hash)
        opts = first
      else
        opts = second
        text = first
      end

      output = if text && block
        raise ActionComponent::RenderError, "An element cannot have both text and a block supplied; choose one or the other"
      elsif text
        @_view.content_tag name, text, opts
      elsif block
        @_view.content_tag name, opts, &block
      else
        @_view.tag name, opts
      end

      @_view.concat(output)

      nil
    end
  end
end
