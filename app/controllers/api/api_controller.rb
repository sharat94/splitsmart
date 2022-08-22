# frozen_string_literal: true

class Api::ApiController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user, :errors

  private

  def initialize
    @errors = []
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
