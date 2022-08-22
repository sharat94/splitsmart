# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



user_1 = User.create!(email: "sharat@splitsmart.com", name: "Sharat", password: "password123", password_confirmation: "password123")
user_2 = User.create!(email: "naresh@splitsmart.com", name: "Naresh", password: "password123", password_confirmation: "password123")
user_3 = User.create!(email: "katrina@splitsmart.com", name: "Katrina", password: "password123", password_confirmation: "password123")


group_1 = Group.create(name: "Sharat-Naresh")
group_1.users << [user_1, user_2]
group_2 = Group.create(name: "Sharat-Naresh-Katrina")
group_2.users <<  [user_1, user_2, user_3]

expense_1 = Expense.create(amount: 100, group_id: group_1.id, split_type: 'EQUAL')
expense_2 = Expense.create(amount: 500, group_id: group_2.id, split_type: 'PERCENTAGE')
expense_3 = Expense.create(amount: 100, group_id: group_2.id, split_type: 'MANUAL')


ExpenseSplit.create(payer_id: user_1.id, payee_id: user_2.id, expense_id: expense_1.id, split_by_value: 50, amount: 50)
ExpenseSplit.create(payer_id: user_2.id, payee_id: user_2.id, expense_id: expense_1.id, split_by_value: 50, amount: 50)

ExpenseSplit.create(payer_id: user_2.id, payee_id: user_1.id, expense_id: expense_2.id, amount: 100)
ExpenseSplit.create(payer_id: user_3.id, payee_id: user_1.id, expense_id: expense_2.id, amount: 300)
ExpenseSplit.create(payer_id: user_1.id, payee_id: user_1.id, expense_id: expense_2.id, amount: 100)


ExpensePayer.create(expense_id: expense_1.id, payer_id: user_1.id, amount: 100)


Settlement.create(payer_id: user_2.id, payee_id: user_1.id, amount: 50)