Rails.application.routes.draw do
  root 'tasks#index'
  get 'search_title' => 'tasks#search_title'
  get 'search_status'=> 'tasks#search_status'
  get 'priority_sort'=> 'tasks#priority_sort'
  resources :tasks

end
