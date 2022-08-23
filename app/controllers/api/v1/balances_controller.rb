class Api::V1::BalancesController < Api::ApiController

  def index
    balance = BalanceService.new(@current_user.id).fetch

    render json: balance
  end
end