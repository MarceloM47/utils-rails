class ApplicationController < ActionController::API
  before_action :authenticate
 
  def authenticate
    if auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      begin
        decoded_token = JWT.decode(
          token, 
          secret, 
          true, 
          { 
            algorithm: 'HS256',
            verify_expiration: true
          }
        )
        @current_user = User.find(decoded_token.first['userid'])
      rescue JWT::ExpiredSignature
        render json: { message: 'Token has expired' }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { message: e.message }, status: :unauthorized
      end
    else
      render json: { message: 'No Authorization token' }, status: :unauthorized
    end
  end
 
  private
 
  def secret
    Rails.application.credentials.secret_key_base
  end
 
  def create_token(payload)
    token_payload = {
      userid: payload[:userid],
      exp: 24.hours.from_now.to_i,
      iat: Time.current.to_i,
      jti: SecureRandom.uuid
    }
    
    JWT.encode(token_payload, secret, 'HS256')
  end
end
