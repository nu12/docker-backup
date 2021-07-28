Rails.application.routes.draw do
  root to: "backup#index"

  # Volume / backup routes
  get 'volume', to: "backup#index", as: :volume_list
  
  post 'backup/create', to: "backup#create", as: :backup_create
  post 'backup/create/:name/:file', to: "backup#create", as: :backup_quick_create
  
  post 'backup/all', to: "backup#batch_all", as: :backup_all
  post 'backup/selected', to: "backup#batch_selected", as: :backup_selected
  
  delete 'volume/:id', to: "backup#delete", as: :volume_delete
  
  # Restore routes
  get 'restore', to: "recover#index", as: :restore_list
  
  post 'restore/create', to: "recover#create", as: :restore_create
  post 'restore/create/:name/:volume', to: "recover#create", name: /[^\/]+/ , as: :restore_quick_create
  
  post 'restore/all', to: "recover#batch_all", as: :restore_all
  post 'restore/selected', to: "recover#batch_selected", as: :restore_selected
  
  get '/restore/upload', to: 'recover#upload', as: :restore_upload
  post '/restore/upload', to: 'recover#save', as: :restore_save
  
  get '/restore/download/:file', to: 'recover#download', as: :restore_download
  
  delete '/restore/:file', to: 'recover#delete', as: :restore_delete
  
  # Session routes
  get 'authenticate', to: "session#new"
  post 'session/create'
  delete 'session/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
