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