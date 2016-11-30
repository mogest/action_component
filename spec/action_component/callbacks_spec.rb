require 'spec_helper'

RSpec.describe ActionComponent::Callbacks do
  class FakeComponent
    prepend ActionComponent::Callbacks

    before_render :test1
    before_render :test2
    after_render :test3

    def test1
    end

    def test2
    end

    def test3
    end

    def view
    end

    def render_view
      view
    end
  end

  subject { FakeComponent.new }

  it "calls the before and after callbacks" do
    expect(subject).to receive(:test1).ordered
    expect(subject).to receive(:test2).ordered
    expect(subject).to receive(:view).ordered.and_return('result')
    expect(subject).to receive(:test3).ordered

    expect(subject.render_view).to eq 'result'
  end
end
