require 'spec_helper'

describe SeriesController do

  describe "POST 'search_remote'" do

    before { login_admin }

    context 'with an empty name' do
      before(:each) do
        post :search_remote, :name => ""
      end

      its(:response) { should render_template :search_remote }

      it 'displays a flash message' do
        flash.now[:alert].should eq("Why don't you try filling in the field?")
      end
    end

    context 'with a valid name' do

      context 'when only one result is found remotely' do

        before(:each) do
          ApiConnector.any_instance.stub(:get_series_from_remote).and_return( [{ :series_id => "555551", :series_name => "The Simpsons", :series_overview => "The overview" }] )
          post :search_remote, :name => "the simpsons"
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
          post :search_remote, :name => "the simpsons"
        end

        it 'should create the found series locally' do
          Series.count.should eq(2)
        end

        its(:response) { should be_success }
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
