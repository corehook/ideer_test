Rails.application.routes.draw do
  get 'templates(/*url)' => 'application#templates'
  root 'welcome#index'


  resources :commits do
    collection do
      post 'parse'
      post 'update_author'
    end
  end

end
