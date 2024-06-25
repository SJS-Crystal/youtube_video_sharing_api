class Api::User::V1::UsersController < Api::User::V1::BaseController
  skip_before_action :authenticate, only: %i[login create]

  $user_desc << 'api/user/v1/users/logout | POST | Authorization(header) | Logout'
  def logout
    @current_user.update!(public_key: nil)
    render json: {message: 'Logged out successfully'}
  end

  $user_desc << 'api/user/v1/users/login | POST | email, password | Login'
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token, public_key = Authentication.generate_token(user)
      user.update!(public_key: public_key)
      render json: {data: {id: user.id, email: user.email, token: token}}
    else
      render json: {message: 'Invalid email or password'}, status: :unauthorized
    end
  end

  $user_desc << 'api/user/v1/users | POST | email, password | Create a new user'
  def create
    user = User.new(email: params[:email], password: params[:password])
    user.save!
    token, public_key = Authentication.generate_token(user)
    user.update!(public_key: public_key)
    render json: {data: {id: user.id, email: user.email, token: token}}, status: :created
  end
end
