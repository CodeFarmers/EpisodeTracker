require 'spec_helper'

describe SeriesUpdater do

  subject { SeriesUpdater }
  it { should respond_to(:execute) }

  let(:series) { FactoryGirl.create(:series) }

  describe "execute" do

    it "should download the latest information" do
      ApiConnector.any_instance.should_receive(:get_series_update).with(series.id)
      SeriesUpdater.execute(series.id)
    end

    it "should update the series information" do

    end
  end
end