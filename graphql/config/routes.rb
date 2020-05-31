Rails.application.routes.draw do
  resources :repositories do
    get "more", on: :collection
    put "star", on: :member
    put "unstar", on: :member
    put "store", on: :collection
  end
  get "/", to: redirect("/repositories")

  resources :graphs do 
  	get "more", on: :collection
    put "star", on: :member
    put "unstar", on: :member
  end
end
