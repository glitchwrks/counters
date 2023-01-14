FactoryBot.define do

  factory :counter do
    sequence(:name) { |n| "counter_#{n}"} 
  end

end
