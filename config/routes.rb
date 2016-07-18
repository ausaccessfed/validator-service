# frozen_string_literal: true
require 'api_constraints'

Rails.application.routes.draw do
  root to: 'welcome#index'
  get '/welcome' => 'welcome#index'
  get '/dashboard' => 'dashboard#dashboard'
  get '/documentation' => 'documentation#index'

  mount ShibRack::Engine => '/auth'
end
