require "rails_helper"

RSpec.describe "Balances", type: :request do
  describe "GET /api/v1/balances" do
    context "when auth token is invalid" do
      let(:token) { JwtService.encode({ id: SecureRandom.uuid }) }
      let(:headers) do
        { "Authorization" => "Bearer #{token}" }
      end

      it "returns 401 unauthorized" do
        get "/api/v1/balances", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when auth token is valid" do
      let!(:user) { create(:user, :with_two_users_group) }
      let!(:expense) { create(:expense, amount: 100, group_id: user.groups.last.id, split_type: 'PERCENTAGE') }
      let!(:expense_splits_1) { create(:expense_split, payer_id: user.groups.first.users.first.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: 10, amount: 10) }
      let!(:expense_splits_2) { create(:expense_split, payer_id: user.groups.first.users.second.id, payee_id: user.groups.first.users.second.id, expense_id: expense.id, split_by_value: 90, amount: 90) }
      let!(:expense_payers) { create(:expense_payer, payer_id: user.id, expense_id: expense.id, amount: 100) }

      let(:token) { JwtService.encode({ id: user.groups.first.users.second.id }) }
      let(:headers) do
        { "Authorization" => "Bearer #{token}" }
      end

      it "returns 200 OK" do
        get "/api/v1/balances", headers: headers

        expect(response).to have_http_status(:success)
      end

      context "when request is made as user 2" do
        let(:token) { JwtService.encode({ id: user.groups.first.users.second.id }) }
        let(:headers) do
          { "Authorization" => "Bearer #{token}" }
        end

        it "shows the balance for the user 2 as 10 to paid to user 1" do
          get "/api/v1/balances", headers: headers

          parsed_response = JSON.parse response.body
          expect(parsed_response.first[1].to_f).to eq(10.0)
        end

      end

      context "when request is made as user 1" do
        let(:token) { JwtService.encode({ id: user.groups.first.users.first.id }) }
        let(:headers) do
          { "Authorization" => "Bearer #{token}" }
        end


        it "shows the balance for the user 1 as 90 to be received from user 2" do

          get "/api/v1/balances", headers: headers

          parsed_response = JSON.parse response.body
          expect(parsed_response.first[1].to_f).to eq(-10.0)
        end
      end
    end
  end
end