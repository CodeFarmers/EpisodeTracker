require 'spec_helper'

describe Series do

  before { @series = Series.new(:name => "Arrested Development", :remote_id => "123") }

  subject { @series }

  it { should respond_to(:name) }
  it { should have_many(:episodes) }

  it "should be able to get saved" do
    expect { @series.save! }.to change(Series, :count).by(1)
  end

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
