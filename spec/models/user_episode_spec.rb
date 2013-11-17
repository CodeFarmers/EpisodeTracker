require 'spec_helper'

describe UserEpisode do
  it { should belong_to(:episode) }
  it { should belong_to(:user) }
  it { should respond_to(:user_id, :episode_id) }
  it { should validate_uniqueness_of(:episode_id).scoped_to(:user_id) }
end