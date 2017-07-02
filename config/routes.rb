# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  mount ShibRack::Engine => '/auth'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: 'welcome#index'

  get '/welcome' => 'welcome#index'
  get '/documentation' => 'documentation#index'

  resources :snapshots, only: %i[index show] do
    collection do
      get 'latest'
    end
  end

  namespace :documentation do
    resources :attributes,
              only: %i[index show],
              id: /[A-Za-z0-9\.\:\-]+?/,
              format: /json|csv|xml|yaml/
    resources :categories, only: %i[index show]
  end
end
