# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, 'workflows-assistant'
set :repo_url, 'git@github.com:pecha7x/workflows-assistant.git'
set :branch, :main #use `git rev-parse --abbrev-ref HEAD`.chomp for pick current branch
set :deploy_to, '/home/deploy/workflows-assistant'
set :pty, true
set :linked_files, %w{config/database.yml config/master.key}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :nvm_node, 'v18.7.0'
set :nvm_map_bins, %w{node npm yarn rake}
