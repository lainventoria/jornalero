class Proyecto < ActiveRecord::Base
  has_many :tareas

  scope :ultimo_mes, -> { joins(:tareas).where('tareas.desde >= ? AND hasta <= ?', Date.today-1.month, Date.today).distinct }

  def to_s
    nombre
  end
end
