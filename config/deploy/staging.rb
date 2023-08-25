set :rails_env, 'staging'
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'staging'))
server '<staging server public IP address>', user: 'deploy', roles: %w{web app db}
