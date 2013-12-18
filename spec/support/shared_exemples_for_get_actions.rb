shared_examples_for "a get action" do | action, options |

  context "for unauthenticated users" do
    it "redirects to the login page" do
        get action, options[:params]
      response.should redirect_to new_user_session_path
    end

    it "should return redirect" do
      get action, options[:params]
      response.should be_redirect
    end
  end
end