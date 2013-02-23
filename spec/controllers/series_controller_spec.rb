require 'spec_helper'

describe SeriesController do

    describe "POST 'find_or_create'" do

      before { login_admin }

      context 'with an empty name' do
        before(:each) do
          post :find_or_create, :name => ""
        end

        its(:response) { should render_template :search }

        it 'displays a flash message' do
          flash.now[:alert].should eq("Why don't you try filling in the field?")
        end
      end

      context 'with a valid name' do

        describe 'when no result in found in the local db' do

          context 'when only one result is found remotely' do

            before(:each) do
              ApiConnector.any_instance.stub(:get_series_from_remote).and_return( [{ :series_id => "555551", :series_name => "The Simpsons", :series_overview => "The overview" }] )
              post :find_or_create, :name => "the simpsons"
              @series = Series.find_by_name("The Simpsons")
            end

            it 'should create the found series locally' do
              Series.count.should eq(1)
            end

            its(:response) { should be_success }

            its(:response) { should render_template @series }
          end

          context 'when more than one result is found remotely' do

            before(:each) do
              ApiConnector.any_instance.stub(:get_series_from_remote).and_return( [{ :series_id => "555551", :series_name => "The Simpsons", :series_overview => "The overview"}, { :series_id => "555552", :series_name => "Jessica Simpson's The Price of Beauty" }] )
              post :find_or_create, :name => "the simpsons"
            end

            it 'should create the found series locally' do
              Series.count.should eq(2)
            end

            its(:response) { should be_success }
          end
        end


      describe 'when a result is found in the local db' do

        before(:each) do
          @series = Series.create(:name => "Huppeldepup", :remote_id => "1515", :overview => "Een overzicht")
          post :find_or_create, :name => @series.name
        end

        its(:response) { should be_success }

        it 'should render the show page for that series' do
          response.should render_template @series
        end
      end
    end
  end

  describe "GET 'search'" do

    it "should work for admins" do
      login_admin
      get :search
      response.should be_success
    end

    it "should not work for non-admins" do
      login_user
      expect { get :search }.to raise_error(CanCan::AccessDenied)
    end

    it "should redirect to the sign in page if not logged in" do
      get :search
      response.should redirect_to new_user_session_path
    end
  end
end
