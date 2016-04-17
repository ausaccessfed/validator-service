# frozen_string_literal: true
require 'api_constraints'

ValidatorService::Application.routes.draw do
  root to: 'test#test'
  get '/test' => 'test#test'
end
