require 'spec_helper'

describe Series do

  let(:series) { Series.new(:name => "Arrested Development", :remote_id => "123") }
  subject { series }

  it { should respond_to(:name) }
  it { should respond_to(:remote_id) }
  it { should respond_to(:overview) }
  it { should have_many(:episodes) }

  it "should be able to get saved" do
    expect { series.save! }.to change(Series, :count).by(1)
  end

  describe "when name is not present" do

    before { series.name = "" }

    it { should_not be_valid }
  end

  describe "when name already exists" do

    before do
      same_series = series.dup
      same_series.save
    end

    it { should_not be_valid }
  end

  describe "#search" do

    let!(:simpsons) { FactoryGirl.create(:series, :name => "The Simpsons") }
    let!(:american) { FactoryGirl.create(:series, :name => "American Dad") }
    let!(:other) { FactoryGirl.create(:series, :name => "The other series") }
    let!(:episode) { FactoryGirl.create(:episode, series_id: other.remote_id) }
    let!(:episode2) { FactoryGirl.create(:episode, series_id: simpsons.remote_id) }
    let!(:episode3) { FactoryGirl.create(:episode, series_id: simpsons.remote_id) }

    it "should be a fuzzy search" do
      results = Series.search("the")
      results.should include(simpsons, other)
      results.should_not include(american)
    end

    it "should return all available series when no search term is provided" do
      results = Series.search(nil)
      results.should include(simpsons, other)
    end

    it "should only return the series that have episodes" do
      Series.search(nil).should include other
    end

    it "should not return series without episodes" do
      Series.search(nil).should_not include american
    end

    it "should only return each series one time" do
      Series.search("The Simpsons").length.should eq(1)
    end

    it "should raise error when no series are found" do
      expect { Series.search("qsdfqf") }.to raise_error(ActionController::RoutingError)
    end
  end
end
