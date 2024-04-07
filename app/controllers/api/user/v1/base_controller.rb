class Api::User::V1::BaseController < ApplicationController
  before_action :authenticate

  $user_desc = []

  rescue_from StandardError, with: :standard_error
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from JWT::ExpiredSignature, with: :jwt_expired_signature
  rescue_from JWT::VerificationError, with: :jwt_verification_error
  rescue_from JWT::DecodeError, with: :jwt_decode_error

  def record_invalid(e)
    render json: {message: e.record.errors.full_messages.join('. ')}, status: :unprocessable_entity
  end

  def record_not_found(e)
    render json: {message: e.message}, status: :not_found
  end

  def jwt_decode_error(e)
    render json: {message: e.message}, status: :unauthorized
  end

  def jwt_expired_signature(e)
    render json: {message: e.message}, status: :unauthorized
  end

  def jwt_verification_error(e)
    render json: {message: e.message}, status: :unauthorized
  end

  def standard_error(e)
    render json: {message: e.message}, status: :internal_server_error
  end

  def authenticate
    payload = Authentication.authorize_token(request.headers['Authorization'])
    @current_user ||= User.find_by(id: payload['user_id'])
  end
end
