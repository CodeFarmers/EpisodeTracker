require "spec_helper"

describe UserEpisodesController do

  describe "post CREATE" do

    context "when not signed in" do

      before { post :create }

      it { should redirect_to new_user_session_path }
    end

    context "when signed in" do

      let(:user_id) { 1 }
      let(:episode_id) { 2 }
      before do
        login_user
        xhr :post, :create, user_id: user_id, episode_id: episode_id
      end


      it "should create the record" do
        lambda do
          xhr :post, :create, user_id: user_id,
                        episode_id: episode_id
        end.should change(UserEpisode, :count).by(1)
      end

      its(:response) { should be_success }

      it "should return JS" do
        response.content_type.should == Mime::JS
      end

      it "should pass on the user_episode" do
        user_episode = assigns(:user_episode)
        user_episode.user_id.should eq(1)
        user_episode.episode_id.should eq(2)
      end
    end
  end
end