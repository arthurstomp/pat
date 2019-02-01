Rails.application.routes.draw do
  root to: "application#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :users, only: :create do
    get '/', to: 'users#show' 
    put '/', to: 'users#update'
    delete '/', to: 'user#delete'
  end
end
