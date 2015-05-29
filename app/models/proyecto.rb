class Proyecto < ActiveRecord::Base
  has_many :tareas

  def to_s
    nombre
  end
end
