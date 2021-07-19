Rails.application.routes.draw do
  root to: "backup#index"

  # Volume / backup routes
  get 'volume', to: "backup#index"

  post 'backup/create', to: "backup#create"

  get 'backup/all', to: "backup#batch_all"
  
  delete 'volume/:id', to: "backup#delete"
  
  # Recovery routes
  get 'recover', to: "recover#index"
  
  post 'recover/create', to: "recover#create"

  get 'recover/all', to: "recover#batch_all"
  
  get '/recover/upload', to: 'recover#upload'
  post '/recover/upload', to: 'recover#save'
  
  get '/recover/download/:file', to: 'recover#download', as: 'download'
  
  delete '/recover/delete/:file', to: 'recover#delete'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
