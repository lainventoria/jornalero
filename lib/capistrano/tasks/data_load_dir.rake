namespace :deploy do
  desc 'Load data from dump'
  task data_load_dir: [:set_rails_env] do
    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:data:load_dir dir=#{fetch(:data_load_dir)}"
        end
      end
    end
  end
end
