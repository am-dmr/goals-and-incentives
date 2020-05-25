Rails.application.routes.draw do
  root to: 'web/v1/dashboard#index'

  namespace :web do
    namespace :v1, path: '1.0' do
      root to: 'dashboard#index'

      devise_for :users

      resources :dashboard, only: %i[index]
      resources :goals do
        member do
          patch :reactualize
        end
      end
      resources :incentives
      resources :dailies, only: [] do
        member do
          patch :increment
          patch :decrement
          get :edit_incentive
          patch :update_incentive
          patch :toggle_incentive_status
        end
        collection do
          patch :freeze
        end
      end
    end
  end
end
