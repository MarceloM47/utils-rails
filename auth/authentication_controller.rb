class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate, only: [:login, :register]

  def login
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
      token = create_token(userid: @user.id)
      render json: {
        status: 'success', 
        token: token, 
        userid: @user.id,
        username: @user.username, 
      }
    else
      render json: { status: 'error', message: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      token = create_token(userid: @user.id)
      render json: { token: token, userid: @user.id }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

 private
 
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
