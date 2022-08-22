# frozen_string_literal: true

class Api::AuthenticationController < ApplicationController
  protect_from_forgery with: :null_session

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
 end
