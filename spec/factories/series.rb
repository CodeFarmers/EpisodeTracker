FactoryGirl.define do

  factory :series do

    sequence :name do |n|
      "someSeries#{n}"
    end

    overview "The Overview"

    sequence :remote_id do |n|
      "#{n}"
    end
  end
end