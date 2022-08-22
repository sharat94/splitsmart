# frozen_string_literal: true

class Api::UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def create_user
    begin
      email = params[:email]
      password = params[:password]
      name = params[:name]
      user = User.find_by(email: params[:email]) || User.new(name: name, email: email, password: password)
      if !user.new_record?
        render json: { errors: 'User Already Exists' }  and return
      end
      user.save!
      render json: {message: 'User successfully created'} if user.errors.blank?
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: "Error with user creation #{e.message}" }
    end
  end
end
