FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    public_key { Faker::Crypto.md5 }
    name { Faker::Name.name }
  end
end
