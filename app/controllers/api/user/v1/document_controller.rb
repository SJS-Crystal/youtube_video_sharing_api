class Api::User::V1::DocumentController < ActionController::Base
  def index
    Api::User::V1::UsersController.new
    Api::User::V1::VideosController.new
    render template: 'layouts/api_documents/user', layout: false
  end
end
