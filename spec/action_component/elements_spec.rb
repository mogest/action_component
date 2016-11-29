require 'spec_helper'

RSpec.describe ActionComponent::Elements do
  class ElementsTest
    include ActionComponent::Elements

    define_tags :custom, :interesting

    def initialize(view)
      @_view = view
    end
  end

  let(:view) { FakeView.new }

  subject { ElementsTest.new(view) }

  describe "::define_tags" do
    it "creates methods for the defined tags" do
      expect(subject.respond_to?(:custom, true)).to be true
      expect(subject.respond_to?(:interesting, true)).to be true
      expect(subject.respond_to?(:does_not_exist, true)).to be false
    end
  end

  describe "#doctype" do
    it "concats a doctype tag" do
      subject.send(:doctype)

      expect(view.calls).to eq [[:concat, '<!doctype html>']]
    end

    it "concats a doctype tag with custom text" do
      subject.send(:doctype, "<test>")

      expect(view.calls).to eq [[:concat, '<!doctype &lt;test&gt;>']]
    end
  end

  describe "an example of a define tag" do
    it "calls element with its tag name as the first parameter" do
      subject.send(:div, "div text", attribute: 'value')

      expect(view.calls).to eq [
        [:content_tag, "div", "div text", {:attribute=>"value"}],
        [:concat, "content_tag [\"div\", \"div text\", {:attribute=>\"value\"}]"]
      ]
    end
  end

  describe "#element" do
    context "when no arguments are specified" do
      it "makes a tag" do
        subject.send(:element, :name)

        expect(view.calls).to eq [
          [:tag, :name, nil],
          [:concat, "tag [:name, nil]"],
        ]
      end
    end

    context "when only one non-hash argument is specified" do
      it "makes a content_tag with that argument" do
        subject.send(:element, :name, "text")

        expect(view.calls).to eq [
          [:content_tag, :name, 'text', nil],
          [:concat, "content_tag [:name, \"text\", nil]"],
        ]
      end
    end

    context "when only one hash argument is specified" do
      it "makes a tag using attributes from that argument" do
        subject.send(:element, :name, blue: 'very')

        expect(view.calls.first).to eq [:tag, :name, {blue: 'very'}]
      end
    end

    context "when two arguments are specified" do
      it "makes a content_tag using the text and attributes" do
        subject.send(:element, :name, 'text', blue: 'very')

        expect(view.calls.first).to eq [:content_tag, :name, 'text', {blue: 'very'}]
      end
    end

    context "when one argument and a block is specified" do
      it "makes a content_tag with the attributes and yields" do
        called = false
        subject.send(:element, :name, blue: 'very') { called = true }

        expect(called).to be true
        expect(view.calls.first).to eq [:content_tag, :name, {blue: 'very'}]
      end
    end

    context "when text and a block are specified" do
      it "raises" do
        expect {
          subject.send(:element, :name, 'hello') { 'yielded' }
        }.to raise_error ActionComponent::RenderError
      end
    end

    context "when the second argument is a string" do
      it "converts the second argument into a hash with the class set" do
        subject.send(:element, :name, 'text', 'blue')

        expect(view.calls.first).to eq [:content_tag, :name, 'text', {class: 'blue'}]
      end
    end

    context "when the second argument is a symbol" do
      it "converts the second argument into a hash with the class set" do
        subject.send(:element, :name, 'text', :blue)

        expect(view.calls.first).to eq [:content_tag, :name, 'text', {class: 'blue'}]
      end
    end
  end
end
