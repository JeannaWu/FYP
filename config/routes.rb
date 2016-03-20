Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :users do
    member do
    get :follow
    get :unfollow
    get :following, :followers
    
end
end




  resources :categories 
   
  

 resources :posts do
 	member do
 		get "like", to:"posts#upvote"
 		get "dislike", to:"posts#downvote"
   
 	end
  member do
     patch :approve, to:"posts#approve"
  end
   match '/posts/:id/approve',  to: 'posts#to_approve'  , via: [:get, :post], as: 'approve_micropost'
  match '/posts/to_approve',  to: 'posts#approve'  , via: :get
 	resources :comments do
      member do
        get "like", to:"comments#upvote"
        get "dislike", to:"comments#downvote"
  end
  end
 end


 
  root 'posts#index'
  get 'static_pages/home'
  get 'static_pages/help'
  resources :follows
  
end
