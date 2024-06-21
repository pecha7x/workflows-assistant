set :rails_env, 'production'
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
server '2.56.205.189', user: 'deploy', roles: %w[web app db nginx]
