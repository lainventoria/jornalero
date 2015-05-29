require "test_helper"

class UsuarioTest < ActiveSupport::TestCase

  def usuario
    @usuario ||= create :usuario
  end

  def test_valid
    assert usuario.valid?
  end

end
