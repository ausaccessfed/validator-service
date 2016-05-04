# frozen_string_literal: true
require 'api_constraints'

ValidatorService::Application.routes.draw do
  root to: 'welcome#index'
  get '/welcome' => 'welcome#index'
  get '/dashboard' => 'dashboard#dashboard'

  mount ShibRack::Engine => '/auth'
end
