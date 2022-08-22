FactoryBot.define do
  factory :group do
    name { Faker::Name.name }
  end

  factory :user_group do
    user_id { Faker::Number.number(digits: 1) }
    group_id { Faker::Number.number(digits: 1) }
  end

  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_two_users_group do
      after :create do |user|
        group = create :group
        user_2 = create :user
        create :user_group, user_id: user.id, group_id: group.id
        create :user_group, user_id: user_2.id, group_id: group.id
      end
    end

    trait :with_three_users_group do
      after :create do |user|
        group = create :group
        user_2 = create :user
        user_3 = create :user
        create :user_group, user_id: user.id, group_id: group.id
        create :user_group, user_id: user_2.id, group_id: group.id
        create :user_group, user_id: user_3.id, group_id: group.id

      end
    end
  end

end