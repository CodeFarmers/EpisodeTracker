require "spec_helper"

describe AdminConfigController do
  render_views

  describe "GET 'show'" do

    context "without a signed in user" do

      before { get :show }

      its(:response) { should be_redirect }

      it "should redirect to the sign in path" do
        response.should redirect_to "/users/sign_in"
      end
    end

    context "with an admin" do

      before(:each) do
        login_admin
        get :show
      end

      its(:response) { should be_success }
      its(:response) { should render_template :show }
    end

    context "with a user" do
      before(:each) do
        login_user
      end

      it "should raise an access denied error" do
        expect { get :show }.to raise_error(CanCan::AccessDenied)
      end
    end

  end

  describe "GET 'search'" do
    context "without a signed in user" do

      before { get :search }

      it "should redirect to the sign in path" do
        response.should redirect_to "/users/sign_in"
      end
    end
  end

    context "with an admin" do

      before(:each) do
        login_admin
        get :search
      end

      its(:response) { should be_success }
      its(:response) { should render_template :search }
    end

  context "with a user" do
    before(:each) do
      login_user
    end

    it "should raise an access denied error" do
      expect { get :search }.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "POST 'search_remote'" do

    context 'as a user without admin rights' do

      before { login_user }

      it "should raise an access denied error" do
        expect { post :search_remote, :name => "the simpsons" }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'as an admin' do

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
  end
end

