## SplitSmart

Find postman docs here -> https://documenter.getpostman.com/view/913809/VUqpvJJ2

## Objective:
- Create a new expense
    - The expense can be split between any number of users
    - The expense can be paid for by any number of users
    - The expense can be split equally / by percentage / manually
- View the list of all expenses split with you, regardless of which user created the
  expense
- View outstanding balances with all the users you have split expenses with in the
  past
- View your overall outstanding balance

## Tech:
Framework: Rails 6.0.5.1

Language: Ruby 3.0.1

DB: Postgres

[Tech Spec](docs/TECH_SPEC.md) 


## Steps to run:

Create local DB: `rails db:create` 

Migrate local DB: `rails db:migrate`

Migrate local DB: `rails db:seed`

Run server: `rails s`

Run tests `rspec`

