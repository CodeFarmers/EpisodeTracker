require 'spec_helper'

describe ApiConnector do
  before(:all) { @ac = ApiConnector.new}
  describe 'initialize' do
    it 'should instantiate an apiconnector' do
      @ac.should_not be_nil
      @ac.should be_instance_of(ApiConnector)
    end
  end

  describe 'set_previous_time' do
    it 'should set the previous time' do
      @ac.should respond_to(:set_previous_time)
      previous_time = @ac.set_previous_time
      previous_time.should_not be_nil
      previous_time.should be_instance_of(String)
    end
  end

  describe 'get series from remote' do

    describe 'when the search returns results' do

      before(:all) { @series = @ac.get_series_from_remote("the simpsons") }

      it 'should return the remote series id' do
        @series[:series_id].should == "71663"
      end

      it 'should return the remote series name' do
        @series[:series_name].should == "The Simpsons"
      end

      it 'should return the remote series overview' do
        @series[:series_overview].should include("Originally created by cartoonist Matt Groening")
      end
    end

    describe 'when the search string is empty' do

      it 'should raise a "NoResultFoundException"' do
        begin
        @ac.get_series_from_remote("")
          ##TODO: make apiconnector raise error
        rescue e
          ap e
          e.should be_instance_of(NoResultFoundException)
        end
      end
    end

    describe 'when the search string is invalid' do

      before(:all) { @series = @ac.get_series_from_remote("someinvalidseriesname") }

      xit 'should raise a "NoResultFoundException"'
    end

  end

end
