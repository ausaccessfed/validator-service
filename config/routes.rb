# frozen_string_literal: true
require 'api_constraints'

Rails.application.routes.draw do
  mount ShibRack::Engine => '/auth'

  root to: 'welcome#index'

  get '/welcome' => 'welcome#index'
  get '/documentation' => 'documentation#index'

  resources :snapshots, only: [:index, :show] do
    collection do
      get 'latest' => 'snapshots#latest'
    end
  end

  namespace :documentation do
    resources :attributes,
              only: [:index, :show],
              id: /[A-Za-z0-9\.\:]+?/,
              format: /json|csv|xml|yaml/
    resources :categories, only: [:index, :show]
  end
end
