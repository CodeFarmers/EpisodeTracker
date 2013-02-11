module ControllerMacros
  def login_admin
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:admin)
  end

  def login_user
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
  end
end