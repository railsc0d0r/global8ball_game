FactoryGirl.define do
  factory :player do
    sequence :name do |n|
      "Player_#{n}"
    end
  end
end
