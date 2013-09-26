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

    it "should be a fuzzy search" do
      results = Series.search("the")
      results.should include(simpsons, other)
      results.should_not include(american)
    end

    it "should return all series when no search term is provided" do
      results = Series.search(nil)
      results.should include(simpsons, american, other)
    end
  end

end
