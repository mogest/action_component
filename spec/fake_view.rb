class FakeView
  attr_reader :calls

  def initialize
    @calls = []
  end

  def datetime_formatter(time)
    time.strftime("%d %B %Y %H:%M")
  end

  def method_missing(method, *args)
    @calls << [method, *args]

    yield if block_given?

    "#{method} #{args.inspect}"
  end
end

