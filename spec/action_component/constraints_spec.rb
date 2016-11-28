require 'spec_helper'

RSpec.describe ActionComponent::Constraints do
  class ConstraintsTest
    include ActionComponent::Constraints

    required :apple, :banana, carrot: String
    optional durian: Hash

    def check(opts)
      check_constraints!(opts)
    end
  end

  subject { ConstraintsTest.new }

  it "passes if all required attributes are supplied" do
    subject.check(apple: 1, banana: 2, carrot: "hello", other: "ignored")
  end

  it "requires required attributes" do
    expect { subject.check(apple: 1) }.to raise_error(ActionComponent::ConstraintError, "banana is required for component ConstraintsTest")

    expect { subject.check(apple: 1, banana: 1) }.to raise_error(ActionComponent::ConstraintError, "carrot is required for component ConstraintsTest")
  end

  it "enforces type for required attributes" do
    expect { subject.check(apple: 1, banana: 1, carrot: 1) }.to raise_error(ActionComponent::ConstraintError, "carrot must be a String")
  end

  it "enforces type for optional attributes" do
    expect { subject.check(apple: 1, banana: 1, carrot: "hello", durian: 1) }.to raise_error(ActionComponent::ConstraintError, "durian must be a Hash")
  end
end
