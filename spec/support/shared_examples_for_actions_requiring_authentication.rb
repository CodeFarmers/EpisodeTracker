shared_examples_for "authentication required" do | action, options |

  options = options || {}

  context "for unauthenticated users" do
    it "redirects to the login page" do
      process(action, options[:params], nil, nil, options[:method])
      response.should redirect_to new_user_session_path
    end

    it "should return redirect" do
      process(action, options[:params], nil, nil, options[:method])
      response.should be_redirect
    end
  end
end