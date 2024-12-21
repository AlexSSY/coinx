Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "webhook#home"

  get "/home", to: "webhook#home", as: :home
  get "/missions", to: "webhook#missions", as: :missions
  get "/wallet", to: "webhook#wallet", as: :wallet
  get "/friends", to: "webhook#friends", as: :friends
  get "/more", to: "webhook#more", as: :more
  get "/terms", to: "webhook#terms_and_conditions", as: :terms

  get "/boost", to: "webhook#boost", as: :boost
  get "/payment/:price", to: "webhook#awaiting_payment", as: :awaiting_payment
  get "/claim", to: "webhook#claim", as: :claim
  post "/claim/create", to: "webhook#claim_create", as: :claim_create
  post "/contest/create", to: "webhook#contest_create", as: :contest_create
  get "/contact_support", to: "webhook#contact_support", as: :contact_support
  get "/legal_information", to: "webhook#legal_information", as: :legal_information
  get "/friends_list", to: "webhook#friends_list", as: :friends_list
  get "/withdraw", to: "webhook#withdraw", as: :withdraw
  post "/withdraw/create", to: "webhook#create_withdraw", as: :create_withdraw
  get "/friends_learn_more", to: "webhook#friends_learn_more", as: :friends_learn_more
  get "/add_content_and_earn", to: "webhook#add_content_and_earn", as: :add_content_and_earn

  get "/mining/get", to: "webhook#get_mining_amount", as: :get_mining_amount
  post "/mining/push", to: "webhook#push_mining_amount", as: :push_mining_amount
  post "/mining/start", to: "webhook#start_mining", as: :start_mining

  # this is for webhook mode
  post "/webhooks/telegram", to: "webhook#home", as: :webhook_telegram
end
