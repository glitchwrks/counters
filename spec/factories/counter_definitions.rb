FactoryBot.define do

  factory :counter do
    sequence(:name) { |n| "counter_#{n}"} 
    ipv4_preload { 0 }
    ipv6_preload { 0 }
  end

  factory :counter_with_hits, :parent => :counter do
    after(:create) do |c|
      FactoryBot.create(:hit, :counter_id => c.id)
      FactoryBot.create(:hit, :ipv6, :counter_id => c.id)
    end
  end

  factory :counter_with_many_hits, :parent => :counter do
    after(:create) do |c|
      25.times do
        FactoryBot.create(:hit, :counter_id => c.id)
        FactoryBot.create(:hit, :ipv6, :counter_id => c.id)
      end
    end
  end

  factory :sitewide_counter do
    sequence(:name) { |n| "sitewide_counter_#{n}"} 
  end

end
