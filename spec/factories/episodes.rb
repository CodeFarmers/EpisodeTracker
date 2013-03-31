FactoryGirl.define do

  factory :episode do

    sequence :name do |n|
      "someEpisode#{n}"
    end

    overview "The Episode Overview"
    series_id 1
  end
end