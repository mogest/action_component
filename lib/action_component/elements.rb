require 'active_support/concern'
require 'active_support/core_ext/string/output_safety'

module ActionComponent
  module Elements
    extend ActiveSupport::Concern
    include ERB::Util

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

    included do
      define_tags *ELEMENTS
    end

    class_methods do
      def define_tags(*element_names)
        element_names.each do |element_name|
          define_method(element_name) do |*args, &block|
            element(element_name, *args, &block)
          end

          private element_name
        end
      end
    end

    private

    def doctype(text = "html")
      @_view.concat("<!doctype #{h(text)}>".html_safe)
    end

    def element(name, first = nil, second = nil, &block)
      if first.is_a?(Hash)
        opts = first
      elsif second.is_a?(String) || second.is_a?(Symbol)
        opts = {class: second.to_s}
        text = first
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

    def e
      ElementBuilder.new(self)
    end
  end
end
