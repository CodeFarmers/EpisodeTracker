require "spec_helper"

describe UserEpisodesController do

  describe "'POST' CREATE" do

    it_behaves_like "authentication required", :create, method: "POST"

    context "when signed in" do

      let(:episode) { FactoryGirl.create(:episode) }
      before do
        login_user
        xhr :post, :create, episode: episode.id
      end

      it "should create the record" do
        user_episode = UserEpisode.where(user_id: @current_user.id, episode_id: episode.id).first
        user_episode.should be_instance_of(UserEpisode)
        user_episode.should_not be_nil
      end

      its(:response) { should be_success }

      it "should return JS" do
        response.content_type.should == Mime::JS
      end

      it "should assign the user_episode" do
        user_episode = assigns(:user_episode)
        user_episode.user_id.should eq(@current_user.id)
        user_episode.episode_id.should eq(episode.id)
      end

    end
  end

  describe "delete DESTROY" do

    it_behaves_like "authentication required", :destroy, {params: {id: 1}, method: "DELETE"}

    context "when signed in" do

      let(:other_user) { FactoryGirl.create(:user) }
      let(:user_episode_for_other_user) { FactoryGirl.create(:user_episode, user: other_user )}
      before do
        login_user
        @user_episode = UserEpisode.create(user_id: @current_user.id , episode_id: 4)
      end

      it "should destroy the correct userepisode" do
        expect do
          xhr :delete, :destroy, id: @user_episode.id
        end.to change(UserEpisode, :count).by(-1)
      end

      it "should render an error if the record does not belong to the user" do
        expect do
          xhr :delete, :destroy, id: user_episode_for_other_user.id
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end
end