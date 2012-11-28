require 'spec_helper'

describe SeriesController do

  describe "POST 'find_or_create'" do

    context 'with an empty name' do
      before(:each) { post :find_or_create, :name => "" }

      its(:response) { should render_template :search }

      it 'displays a flash message' do
        flash.now[:alert].should eq("Why don't you try filling in the field?")
      end
    end

    #context 'with an invalid name' do
    #  @ac = ApiConnector.new
    #  @ac.stub(:get_series_from_remote)
    #  post :find_or_create, :name => "qsdfqsdf"
    #
    #
    #end

    context 'with a valid name' do

      describe 'when no result in found in the local db' do
        before(:each) do
          ApiConnector.any_instance.stub(:get_series_from_remote).and_return({ 0 => { :series_id => "555551", :series_name => "The Simpsons", :series_overview => "The overview"}, 1 => { :series_id => "555552", :series_name => "Jessica Simpson's The Price of Beauty"}})
          post :find_or_create, :name => "the simpsons"
        end

        it 'should create the found series locally' do
          Series.count.should eq(2)
        end
        its(:response) { should be_success }
      end

      describe 'when a result is found in the local db' do

        before(:each) do
          Series.create(:name => "Huppeldepup", :remote_id => "1515", :overview => "Een overzicht")
          post :find_or_create, :name => "Huppeldepup"
        end

        its(:response) { should be_success }

        it 'should render the show page for that series' do
          response.should render_template :show
        end
      end
    end
  end
end
