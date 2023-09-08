# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'workflows-assistant'
set :repo_url, 'git@github.com:pecha7x/workflows-assistant.git'
set :branch, :main # use `git rev-parse --abbrev-ref HEAD`.chomp for pick current branch
set :deploy_to, '/home/deploy/workflows-assistant'
set :pty, true
set :linked_files, %w[config/database.yml config/master.key config/credentials/production.key config/credentials/production.yml.enc]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads]
set :keep_releases, 5
set :nvm_node, 'v18.7.0'
set :nvm_map_bins, %w[node npm yarn rake]

namespace :sidekiq do
  task :quiet do
    on roles(:app) do
      # puts capture("pgrep -f 'sidekiq' | xargs kill -TSTP")
      within release_path do
        # execute :bundle, 'exec sidekiqctl quiet', 'tmp/pids/sidekiq.pid'
      end
    end
  end
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :sidekiq
    end
  end
end

namespace :deploy do
  namespace :nginx do
    desc 'Reload nginx configuration'
    task :reload do
      on roles :nginx do
        sudo 'service nginx reload'
      end
    end

    desc 'Symlink Nginx config'
    task :symlink_config do
      on roles :nginx do
        within release_path do
          sudo :cp, '-f', "config/nginx.#{fetch(:stage)}.conf", '/etc/nginx/nginx.conf'
        end
      end
    end
  end
end

# after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'

after 'deploy:updated', 'deploy:nginx:symlink_config'
after 'deploy:updated', 'deploy:nginx:reload'
