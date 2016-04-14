# frozen_string_literal: true
require File.expand_path('../config/application', __FILE__)
ValidatorService::Application.load_tasks

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:spec, :rubocop]
