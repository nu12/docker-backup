Rails.application.routes.draw do
  root to: "backup#index"
  get 'recover', to: "recover#index"
  get 'recover/new'
  post 'recover/create'
  get 'backup', to: "backup#index"
  get 'backup/new'
  post 'backup/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
