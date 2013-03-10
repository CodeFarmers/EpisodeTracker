require 'spec_helper'

describe Series do

  before { @series = Series.new(:name => "Arrested Development") }

  subject { @series }

  it { should respond_to(:name) }
  it { should have_many(:episodes) }

  describe "when name is not present" do

    before { @series.name = "" }

    it { should_not be_valid }
  end

  describe "when name already exists" do

    before do
      same_series = @series.dup
      same_series.save
    end

    it { should_not be_valid }
  end
end
