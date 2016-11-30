module ActionComponent
  class ElementBuilder
    def initialize(base, element_name = nil, classes = nil, id = nil)
      @base = base
      @element_name = element_name
      @classes = classes
      @id = id
    end

    def method_missing(method, *args, &block)
      element_name = @element_name
      classes = @classes
      id = @id

      command = method.to_s

      command = command[-1] == '?' ? command[0..-2] : command.gsub('_', '-')

      if element_name
        if command[-1] == '!'
          id = command[0..-2]
        else
          classes = classes ? "#{classes} #{command}" : command
        end
      else
        element_name = command
      end

      if !args.empty? || block
        first, second = args

        if second.is_a?(Hash)
          build_options(classes, id, second)
        elsif first.is_a?(Hash)
          build_options(classes, id, first)
        elsif first
          second = build_options(classes, id)
        else
          first = build_options(classes, id)
        end

        @base.send(:element, element_name, first, second, &block)
      else
        self.class.new(@base, element_name, classes, id)
      end
    end

    private

    def build_options(classes, id, options = {})
      if classes
        if options[:class]
          options[:class] = "#{options[:class]} #{classes}"
        else
          options[:class] = classes
        end
      end

      options[:id] = id if id

      options
    end
  end
end
