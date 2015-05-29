ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'
require 'minitest/rails'
require 'minitest/rails/capybara'

ActiveRecord::Migration.check_pending!

# Empezar con una base de pruebas vacía
DatabaseCleaner.clean_with :truncation, pre_count: true

# Revisar la validez de las factories definidas
FactoryGirl.lint

# Volver a vaciarla por el lint
DatabaseCleaner.clean_with :truncation, pre_count: true

# Usar transacciones y rollback
DatabaseCleaner.strategy = :transaction

# Clase madre de los tests de unidad
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

# Clase madre de los tests de features o integración
class Capybara::Rails::TestCase
  # No podemos usar transacciones con selenium
  DatabaseCleaner.strategy = :truncation
  self.use_transactional_fixtures = false

  # A veces google maps demora mucho
  Capybara.default_wait_time = 15

  teardown do
    DatabaseCleaner.clean
    # Reiniciar el estado del navegador
    Capybara.reset_sessions!
    # Volver al driver default si lo cambiamos a selenium temporalmente
    Capybara.use_default_driver
  end

  # Crea una cuenta adhoc y la loguea, devolviendo la cuenta creada
  def login_adhoc
    cuenta = create :usuario, password: '12345678'

    visit new_usuario_session_path

    fill_in 'usuario_email', with: cuenta.email
    fill_in 'usuario_password', with: '12345678'

    click_button 'Ingresar'

    cuenta
  end

end

# Registrando el driver podemos pasar opciones como el profile a usar
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new app, browser: :firefox, profile: ENV['PROFILE']
end
