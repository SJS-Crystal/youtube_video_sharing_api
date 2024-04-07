FactoryBot.define do
  factory :video do
    youtube_id { Faker::Lorem.characters(number: 11) }
    title { Faker::Lorem.characters(number: 20) }
    description { Faker::Lorem.characters(number: 20) }
    association :user, factory: :user
  end
end
