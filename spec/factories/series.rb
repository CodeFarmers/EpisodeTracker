FactoryGirl.define do

  factory :series do
    sequence :name do |n|
      "someSeries#{n}"
    end
    overview "The Overview"
    sequence :remote_id do |n|
      "#{n}"
    end

    #factory :series_with_episodes do
    #  ignore do
    #    episodes_count 3
    #  end
    #  after(:create) do |series, evaluator|
    #    ap FactoryGirl.create_list(:episode, evaluator.episodes_count, series: series)
    #  end
    #end
  end
end