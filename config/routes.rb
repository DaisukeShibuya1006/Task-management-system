Rails.application.routes.draw do
  root 'tasks#index'
  get 'index' => 'tasks#index'
  resources :tasks

  get 'users/new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout'=> 'sessions#destroy'

end
