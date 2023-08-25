set :rails_env, 'production'
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
server '195.250.79.121', user: 'deploy', roles: %w{web app db}, port: 2257