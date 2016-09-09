# frozen_string_literal: true

config = YAML.load_file(File.expand_path('../deploy.yml', __FILE__))
puma_config = config['puma']
env = ENV.fetch('RAILS_ENV') { 'development' }

preload_app!
daemonize unless env == 'development'

port puma_config['port']
environment env
workers 2
threads 8, 32
tag 'validator'
pidfile 'tmp/pids/puma.pid'

stdout_redirect puma_config['stdout'],
                puma_config['stderr'],
                :append
