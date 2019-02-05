Rails.application.routes.draw do
  get '*path',
    to: 'application#root',
    constraints: lambda{|req| req.headers["content-type"] != "application/json"}
  root to: "application#root"

  resources :companies, except: [:new, :edit] do
    get '/report', to: "companies#report", on: :member
    resources :departments, on: :member
  end
  resources :users, except: [:new, :edit] do
    post '/login', to: 'users#login', on: :collection
  end
  resources :jobs, except: [:delete], controller: :employees
end
