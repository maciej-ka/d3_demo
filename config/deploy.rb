# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'd3_demo'
set :repo_url, 'git@github.com:lokson/d3_demo.git'
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  def execute_in_current(*args)
    on roles(:app) do
      within release_path do
        execute *args
      end
    end
  end

  task :permit_temp do
    execute_in_current :chmod, "777 -R tmp"
  end

  task :restart do
    execute_in_current :touch, 'touch tmp/restart.txt'
  end

  task :assets_clean do
    return if !fetch :rails_env
    execute_in_current :bundle, "exec rake assets:clean RAILS_ENV=#{fetch :rails_env}"
  end

  task :assets_precompile do
    return if !fetch :rails_env
    execute_in_current :bundle, "exec rake assets:clean RAILS_ENV=#{fetch :rails_env}"
    execute_in_current :bundle, "exec rake assets:precompile RAILS_ENV=#{fetch :rails_env}"
  end

  task :update_bins do
    execute_in_current :rm, "-rf #{release_path}/bin"
    execute_in_current :bundle, "exec rake rails:update:bin"
  end

  task :db_reset do
    return if !fetch :rails_env
    execute_in_current :bundle, "exec rake db:reset RAILS_ENV=#{fetch :rails_env}"
  end

  task :bundle do
    execute_in_current :bundle
  end

  task :wsoc_start do
    return if !fetch :rails_env
    execute_in_current :bundle, "exec rake websocket_rails:start_server RAILS_ENV=#{fetch :rails_env}"
  end

  task :wsoc_stop do
    return if !fetch :rails_env
    execute_in_current :bundle, "exec rake websocket_rails:stop_server RAILS_ENV=#{fetch :rails_env}"
  end
  task :redis_start do
    execute_in_current :service, 'redis-server start'
  end

  task :redis_stop do
    execute_in_current :service, 'redis-server stop'
  end

  task :wsoc_log do
    execute_in_current "{ tail -f #{release_path}/log/websocket_rails.log & tail -f #{release_path}/log/websocket_rails_server.log; }"
  end

  task :log do
    execute_in_current :tail, "-f log/#{fetch :rails_env}.log"
  end

  task :nginx_stop do
    execute_in_current :service, "nginx stop"
  end

  task :nginx_start do
    execute_in_current :service, "nginx start"
  end

  # after :publishing, :log
  # after :publishing, :wsoc_log

  # after :publishing, :wsoc_stop
  # after :publishing, :wsoc_start
  # after :publishing, :redis_start
  # after :publishing, :redis_stop
  # after :publishing, :wsoc_port_open
  # after :publishing, :wsoc_port_close

  after :publishing, :permit_temp
  after :publishing, :update_bins
  after :publishing, :assets_clean
  after :publishing, :assets_precompile

  after :publishing, :nginx_stop
  after :publishing, :db_reset
  after :publishing, :nginx_start

  after :publishing, :restart
end
