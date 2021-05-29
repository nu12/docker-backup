Rails.application.routes.draw do
  root to: "backup#index"

  # Volume / backup routes
  get 'volume', to: "backup#index"
  
  get 'backup/new/:name', to: "backup#new"
  post 'backup/create'
  
  delete 'volume/:id', to: "backup#delete"
  
  # Recovery routes
  get 'recover', to: "recover#index"
  
  get 'recover/new/:name', to: "recover#new"
  post 'recover/create'
  
  get '/recover/upload', to: 'recover#upload'
  post '/recover/upload', to: 'recover#save'
  
  get '/recover/download/:file', to: 'recover#download', as: 'download'
  
  delete '/recover/delete/:file', to: 'recover#delete'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
