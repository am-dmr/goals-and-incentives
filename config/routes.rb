Rails.application.routes.draw do
  root to: 'web/v1/dashboard#index'

  namespace :web do
    namespace :v1, path: '1.0' do
      root to: 'dashboard#index'

      devise_for :users
    end
  end
end
