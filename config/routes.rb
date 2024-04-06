Rails.application.routes.draw do
  namespace :api do
    namespace :user do
      namespace :v1 do
        get '/' => 'document#index'
        resources :users, only: [] do
          collection do
            post :login
          end
        end
      end
    end
  end
end
