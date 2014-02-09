FactoryGirl.define do

  factory :episode do
    sequence :name do |n|
      "someEpisode#{n}"
    end
    overview "The Episode Overview"
    remote_id "15511"
    series
  end
end