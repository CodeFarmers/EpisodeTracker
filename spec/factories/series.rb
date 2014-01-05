FactoryGirl.define do

  factory :series do
    sequence :name do |n|
      "someSeries#{n}"
    end
    overview "The Overview"
    sequence :remote_id do |n|
      "#{n}"
    end
    last_remote_update "1362939962"
  end
end