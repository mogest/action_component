require 'spec_helper'

RSpec.describe ActionComponent::ElementBuilder do
  class FakeBase
    def element(*args, &block)
      [*args, block]
    end
  end

  let(:base) { FakeBase.new }

  subject { ActionComponent::ElementBuilder.new(base) }

  it "builds a simple element" do
    expect(subject.simple("test")).to eq ['simple', 'test', {}, nil]
  end

  it "builds an element with a class" do
    expect(subject.simple.blue("test")).to eq ['simple', 'test', {class: 'blue'}, nil]
  end

  it "builds an element with two classes" do
    expect(subject.simple.blue.loud("test")).to eq ['simple', 'test', {class: 'blue loud'}, nil]
  end

  it "builds an element with an id" do
    expect(subject.simple.blue!("test")).to eq ['simple', 'test', {id: 'blue'}, nil]
  end

  it "converts underscores to dashes" do
    expect(subject.simple.strong_blue("test")).to eq ['simple', 'test', {class: 'strong-blue'}, nil]
  end

  it "does not convert underscores to dashes if the method ends in a ?" do
    expect(subject.simple.strong_blue?("test")).to eq ['simple', 'test', {class: 'strong_blue'}, nil]
  end

  it "merges classes with ones specified in the hash" do
    expect(subject.simple.blue("test", testy: "very", class: "strong")).to eq ['simple', 'test', {testy: "very", class: 'strong blue'}, nil]
  end

  it "passes just a block" do
    block = -> {}

    expect(subject.simple.blue(&block)).to eq ['simple', {class: 'blue'}, nil, block]
  end

  it "passes a block with a hash" do
    block = -> {}

    expect(subject.simple.blue(testy: "very", &block)).to eq ['simple', {testy: "very", class: 'blue'}, nil, block]
  end
end
