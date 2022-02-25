Rails.application.routes.draw do
  get 'account', to: 'account#show'
  root 'static_pages#home'
  passwordless_for :users
  resources :users, only: %i[show new create] do
    resources :workspaces, except: %i[show]
  end

  scope path: ':workspace_id', as: 'workspace' do
    resources :items
    resources :groups, only: %i[show edit update create]
    get 'search', to: 'items#index', as: :search_items
    root 'items#index', as: :workspace_items
  end
end
