Rails.application.routes.draw do
  namespace :api do
    namespace :user do
      namespace :v1 do
        get '/' => 'document#index'
        resources :users, only: [:create] do
          collection do
            post :login
            delete :logout
          end
        end

        resources :videos, only: [:index, :create]
      end
    end
  end
end
