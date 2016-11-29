require 'spec_helper'

RSpec.describe ActionComponent::Base do
  let(:view) { double }
  let(:opts) { {option: 'value'} }

  subject { ActionComponent::Base.new(view, opts) }

  describe "::render" do
    it "makes a new component, then calls load and view, returning nil" do
      component = instance_double(ActionComponent::Base)
      expect(component).to receive(:load).ordered
      expect(component).to receive(:view).ordered

      expect(ActionComponent::Base).to receive(:new)
        .with(view, {option: 'value'})
        .and_return(component)

      result = ActionComponent::Base.render(view, option: 'value')
      expect(result).to be nil
    end
  end

  describe "#load" do
    it "does nothing" do
      expect(subject.load).to be nil
    end
  end

  describe "#view" do
    it "raises" do
      expect { subject.view }.to raise_error ActionComponent::ViewMissingError
    end
  end

  describe "private methods used by subclasses" do
    class AuthorComponent < ActionComponent::Base
      def view
        div @author
      end
    end

    class TestComponent < ActionComponent::Base
      def view
        div(class: "post") do
          h2 @post.title

          div datetime_formatter(@post.posted_at), class: "datetime"

          text "!"

          render "some_view"

          component AuthorComponent, author: @post.author
        end
      end
    end

    let(:post) do
      double(
        title:     "Test Post",
        author:    "Roger Nesbitt",
        posted_at: Time.parse("2016-11-28 11:09:20"),
      )
    end

    let(:view) { FakeView.new }

    it "renders the component" do
      result = TestComponent.render(view, post: post)
      expect(result).to be nil

      expect(view.calls).to eq [
        [:content_tag, "div", {:class=>"post"}],
        [:content_tag, "h2", "Test Post", nil],
        [:concat, "content_tag [\"h2\", \"Test Post\", nil]"],
        [:content_tag, "div", "28 November 2016 11:09", {:class=>"datetime"}],
        [:concat, "content_tag [\"div\", \"28 November 2016 11:09\", {:class=>\"datetime\"}]"],
        [:concat, "!"],
        [:render, "some_view"],
        [:concat, "render [\"some_view\"]"],
        [:content_tag, "div", "Roger Nesbitt", nil],
        [:concat, "content_tag [\"div\", \"Roger Nesbitt\", nil]"],
        [:concat, "content_tag [\"div\", {:class=>\"post\"}]"],
      ]
    end
  end
end
