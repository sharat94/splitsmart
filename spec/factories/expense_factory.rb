FactoryBot.define do
  factory :expense do
    amount { Faker::Number.number(digits: 3) }
    group_id { Faker::Number.number(digits: 1) }
    split_type { 'EQUAL' }
  end

  factory :expense_split do
    payer_id { Faker::Number.number(digits: 1) }
    payee_id { Faker::Number.number(digits: 1) }
    expense_id { Faker::Number.number(digits: 1) }
    split_by_value { Faker::Number.number(digits: 2) }
    amount { Faker::Number.number(digits: 2) }
  end

  factory :expense_payer do
    payer_id { Faker::Number.number(digits: 1) }
    expense_id { Faker::Number.number(digits: 1) }
    amount { Faker::Number.number(digits: 2) }
  end
end