# Nueva tarea para correr los feature tests
Rails::TestTask.new('test:features' => 'test:prepare') do |t|
  t.pattern = 'test/features/**/*_test.rb'
end

# Correrlos por default
Rake::Task['test:run'].enhance ['test:features']
