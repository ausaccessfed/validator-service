# frozen_string_literal: true
ValidatorService::Application.routes.draw do
  mount RapidRack::Engine => '/auth'
end
