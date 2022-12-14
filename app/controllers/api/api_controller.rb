# frozen_string_literal: true

class Api::ApiController < ApplicationController
  before_action :authenticate_request

  around_action :exception_handling
  attr_reader :current_user, :errors

  private

  def exception_handling
    yield
  rescue ArgumentError => e
    render_error(e.message, :unprocessable_entity)
  rescue ActiveRecord::RecordNotFound
    render_error("Resource not found", :not_found)
   end

  def render_error(error_message, status)
    render json: { message: error_message }, status: status
  end

  def initialize
    @errors = []
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).authorize
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Not Authorized' }, status: 401
  end
end
