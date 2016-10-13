Rails.application.routes.draw do

  resources :childcare_resources

  get 'home/index'
  get '/search', to: 'home#search'

  namespace :api do
    namespace :v1 do
      resources :contracts
      resources :children
      resources :settings
      resources :scales
      resources :age_groups
      resources :providers do
        post :close_month, on: :member
      end
      resources :provider_attendances, only: [:index, :update]
    end
  end

  resources :attendances do
    get :print, on: :collection
  end
  resources :settings, only: [:index]
  resources :family_notes
  resources :contracts

  resources :families do
    member do
      get :award_letter
      get :provider_letter
      get :redeterminate
      get :termination_notice
      get :information_request
      get :redetermination_notice
      get :redetermination_denial_letter
      post :reject
      patch :update_redetermination
    end
    resources :children, only: [:show]
  end

  resources :providers do
    resources :provider_rates
    get :attendances, on: :member
  end

  resources :payouts, only: [:destroy]

  resources :funders do
    resources :funding_cycles
  end

  resources :funding_cycles
  resources :accounts

  resources :reports do
    collection do
      get :redetermination_due
      get :provider_payment
      get :provider_payment_due
      get :family_average_income
      get :children_per_provider
      get :fiscal_year
      get :funding_source_historical_contract
      get :balance_remaining_per_funder
      get :reimbursement
      get :termination
      get :payouts
    end
  end

  resources :settings do
    put :update_county_rate, on: :member
  end

  devise_for :users, controllers: {
    registrdations: 'registrations',
    sessions: 'sessions',
    passwords: 'passwords'
  }

  root 'home#index'

end
