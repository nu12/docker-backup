Rails.application.routes.draw do
  root to: "backup#index"

  # Volume / backup routes
  get 'volume', to: "backup#index"

  post 'backup/create', to: "backup#create"
  post 'backup/create/:name/:file', to: "backup#create"

  post 'backup/all', to: "backup#batch_all"
  post 'backup/selected', to: "backup#batch_selected"
  
  delete 'volume/:id', to: "backup#delete"
  
  # Recovery routes
  get 'recover', to: "recover#index"
  
  post 'recover/create', to: "recover#create"
  post 'recover/create/:name/:volume', to: "recover#create", name: /[^\/]+/ 

  post 'recover/all', to: "recover#batch_all"
  post 'recover/selected', to: "recover#batch_selected"
  
  get '/recover/upload', to: 'recover#upload'
  post '/recover/upload', to: 'recover#save'
  
  get '/recover/download/:file', to: 'recover#download', as: 'download'
  
  delete '/recover/delete/:file', to: 'recover#delete'
  
  # Session routes
  get 'authenticate', to: "session#new"
  post 'session/create'
  delete 'session/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
