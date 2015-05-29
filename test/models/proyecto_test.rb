require "test_helper"

class ProyectoTest < ActiveSupport::TestCase

  def proyecto
    @proyecto ||= Proyecto.new
  end

  def test_valid
    assert proyecto.valid?
  end

end
