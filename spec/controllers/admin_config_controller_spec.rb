require "rspec"
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
end