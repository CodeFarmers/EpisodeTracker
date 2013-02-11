FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      "jos.bos#{n}@los.be"
    end
    password "testtest"
    admin false
  end

  factory :admin, class: User do
    sequence :email do |n|
      "tom.lauwyck#{n}@gmail.com"
    end
    password "testtest"
    admin true
  end
end