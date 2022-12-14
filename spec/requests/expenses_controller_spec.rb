require "rails_helper"

RSpec.describe "Expenses", type: :request do
  describe "POST /api/v1/expenses" do
    context "when auth token is invalid" do
      let(:token) { JwtService.encode({ id: SecureRandom.uuid }) }
      let(:headers) do
        { "Authorization" => "Bearer #{token}" }
      end

      it "returns 401 unauthorized" do
        post "/api/v1/expenses", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when auth token is valid" do

      context "when the split type is `EQUAL`" do
        let!(:user) { create(:user, :with_three_users_group) }
        let!(:token) { JwtService.encode({ id: user.id }) }
        let!(:headers) do
          { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
        end

        let(:params) {
          {
            "amount": 300,
            "split_type": "EQUAL",
            "group_id": user.groups.last.id,
            "paid_by": [
              {
                "user_id": user.groups.first.users.first.id,
                "paid_amount": 200
              },
              {
                "user_id": user.groups.first.users.second.id,
                "paid_amount": 100
              }
            ]

          }
        }

        it "returns 200 success" do
          post "/api/v1/expenses", headers: headers, params: params.to_json

          expect(response).to have_http_status(:success)
        end

      end

      context "when the split type is `PERCENTAGE`" do

        let!(:user) { create(:user, :with_three_users_group) }
        let!(:token) { JwtService.encode({ id: user.id }) }
        let!(:headers) do
          { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
        end

        let(:params) {
          {
            "amount": 300,
            "split_type": "PERCENTAGE",
            "group_id": user.groups.last.id,
            "split_by": [
              {
                "user_id": user.groups.first.users.first.id,
                "value": 10
              },
              {
                "user_id": user.groups.first.users.second.id,
                "value": 30
              },
              {
                "user_id": user.groups.first.users.last.id,
                "value": 60
              }
            ],
            "paid_by": [
              {
                "user_id": user.groups.first.users.first.id,
                "paid_amount": 200
              },
              {
                "user_id": user.groups.first.users.second.id,
                "paid_amount": 100
              }
            ]

          }
        }

        it "returns 200 success" do
          post "/api/v1/expenses", headers: headers, params: params.to_json

          expect(response).to have_http_status(:success)
        end
      end

      context "when the split type is `MANUAL`" do

        let!(:user) { create(:user, :with_three_users_group) }
        let!(:token) { JwtService.encode({ id: user.id }) }
        let!(:headers) do
          { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
        end

        let(:params) {
          {
            "amount": 300,
            "split_type": "MANUAL",
            "group_id": user.groups.last.id,
            "split_by": [
              {
                "user_id": user.groups.first.users.first.id,
                "value": 100
              },
              {
                "user_id": user.groups.first.users.second.id,
                "value": 50
              },
              {
                "user_id": user.groups.first.users.last.id,
                "value": 150
              }
            ],
            "paid_by": [
              {
                "user_id": user.groups.first.users.first.id,
                "paid_amount": 200
              },
              {
                "user_id": user.groups.first.users.second.id,
                "paid_amount": 100
              }
            ]

          }
        }

        it "returns 200 success" do
          post "/api/v1/expenses", headers: headers, params: params.to_json

          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe "GET /api/v1/expenses" do
    context "when auth token is invalid" do
      let(:token) { JwtService.encode({ id: SecureRandom.uuid }) }
      let(:headers) do
        { "Authorization" => "Bearer #{token}" }
      end

      it "returns 401 unauthorized" do
        post "/api/v1/expenses", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "when auth token is valid" do
      context "when valid EQUAL expense is added" do
        let!(:user) { create(:user, :with_two_users_group) }
        let!(:expense) { create(:expense, amount: 100, group_id: user.groups.last.id, split_type: 'EQUAL') }
        let!(:expense_splits_1) { create(:expense_split, payer_id: user.groups.first.users.first.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: 50, amount: 50) }
        let!(:expense_splits_2) { create(:expense_split, payer_id: user.groups.first.users.second.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: 50, amount: 50) }
        let!(:token) { JwtService.encode({ id: user.id }) }
        let!(:headers) do
          { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
        end

        it "returns 200 OK" do
          get "/api/v1/expenses", headers: headers

          expect(response).to have_http_status(:success)
        end

        it "returns all the expenses of the user" do
          get "/api/v1/expenses", headers: headers

          parsed_response = JSON.parse response.body
          expect(parsed_response.first["amount"]).to eq(expense.amount.to_s)
          expect(parsed_response.size).to eq(1)
        end
      end

      context "when valid MANUAL expense is added" do
        let!(:user) { create(:user, :with_two_users_group) }
        let!(:expense) { create(:expense, amount: 100, group_id: user.groups.last.id, split_type: 'MANUAL') }
        let!(:expense_splits_1) { create(:expense_split, payer_id: user.groups.first.users.first.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: nil, amount: 30) }
        let!(:expense_splits_2) { create(:expense_split, payer_id: user.groups.first.users.second.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: nil, amount: 70) }
        let!(:token) { JwtService.encode({ id: user.id }) }
        let!(:headers) do
          { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
        end

        it "returns 200 OK" do
          get "/api/v1/expenses", headers: headers

          expect(response).to have_http_status(:success)
        end
      end

      context "when valid PERCENTAGE expense is added" do
        let!(:user) { create(:user, :with_two_users_group) }
        let!(:expense) { create(:expense, amount: 100, group_id: user.groups.last.id, split_type: 'PERCENTAGE') }
        let!(:expense_splits_1) { create(:expense_split, payer_id: user.groups.first.users.first.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: 10, amount: 10) }
        let!(:expense_splits_2) { create(:expense_split, payer_id: user.groups.first.users.second.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: 90, amount: 90) }
        let!(:token) { JwtService.encode({ id: user.id }) }
        let!(:headers) do
          { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
        end

        it "returns 200 OK" do
          get "/api/v1/expenses", headers: headers

          expect(response).to have_http_status(:success)
        end
      end

    end
  end
end