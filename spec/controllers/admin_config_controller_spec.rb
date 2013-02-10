require "rspec"

describe AdminConfigController do

  describe "GET 'show'" do

    before { get :show }

    its(:response) { should render_template :show }
  end
end