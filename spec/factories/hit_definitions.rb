FactoryBot.define do

  factory :hit do
    address { '1.2.3.4' }
    ipv6 { false }

    trait :ipv6 do
      address { '2001:db8:1::1' }
      ipv6 { true }
    end
  end

end
