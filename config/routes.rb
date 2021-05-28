Rails.application.routes.draw do
  root to: "backup#index"
  get 'recover', to: "recover#index"
  get 'recover/new/:name', to: "recover#new"
  post 'recover/create'
  get 'volume', to: "backup#index"
  delete 'volume/:id', to: "backup#delete"
  get 'backup/new/:name', to: "backup#new"
  post 'backup/create'


  get '/recover/download/:file', to: 'recover#download', as: 'download'
  get '/recover/delete/:file', to: 'recover#delete'
  get '/recover/upload', to: 'recover#upload'
  post '/recover/upload', to: 'recover#save'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
