Rails.application.routes.draw do
  root 'tasks#index'
  get 'search_title_status' => 'tasks#search_title_status'
  get 'priority_sort'=> 'tasks#priority_sort'
  resources :tasks

end
