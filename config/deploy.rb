lock '3.3.5'

set :application, 'jornalero'
set :repo_url, 'https://github.com/lainventoria/jornalero.git'

# Defaults de capistrano que usamos
# set :branch, :master
# set :scm, :git
# set :format, :pretty
# set :log_level, :debug
# set :pty, false
# set :keep_releases, 5

set :linked_files, %w{.env}

namespace :deploy do
end
