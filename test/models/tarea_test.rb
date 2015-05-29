require "test_helper"

class TareaTest < ActiveSupport::TestCase

  def tarea
    @tarea ||= Tarea.new
  end

  def test_valid
    assert tarea.valid?
  end

end
