# frozen_string_literal: true

config = YAML.load_file(File.expand_path('../deploy.yml', __FILE__))
puma_config = config['puma']

preload_app!
daemonize unless ENV.fetch('RAILS_ENV') == 'development'

port puma_config['port']
environment ENV.fetch('RAILS_ENV') { 'development' }
workers 2
threads 8, 32
tag 'validator'
pidfile 'tmp/pids/puma.pid'

stdout_redirect puma_config['stdout'],
                puma_config['stderr'],
                :append
