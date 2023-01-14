FactoryBot.define do

  factory :hit do
  	sequence(:address) { |n| "1.2.3.#{n}" }
    ipv6 { false }

    trait :ipv6 do
      sequence(:address) { |n| "2001:db8:1::#{n.to_s(16)}" }
      ipv6 { true }
    end
  end

end
