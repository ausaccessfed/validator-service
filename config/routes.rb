# frozen_string_literal: true
require 'api_constraints'

Rails.application.routes.draw do
  mount ShibRack::Engine => '/auth'

  root to: 'welcome#index'

  get '/welcome' => 'welcome#index'
  get '/dashboard' => 'dashboard#dashboard'
  get '/documentation' => 'documentation#index'

  namespace :documentation do
    resources :attributes,
              only: [:index, :show],
              id: /[A-Za-z0-9\.\:]+?/,
              format: /json|csv|xml|yaml/
    resources :categories, only: [:index, :show]
  end
end
