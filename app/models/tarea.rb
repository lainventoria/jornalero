class Tarea < ActiveRecord::Base
  belongs_to :proyecto
  belongs_to :usuario

  scope :entre, ->(desde, hasta) { where('desde <= ? AND hasta >= ?', desde, hasta) }
  scope :intersectando, ->(desde, hasta) { where('desde >= ? AND hasta <= ?', desde, hasta) }
  scope :semana, ->(fecha) { intersectando( fecha, fecha + 1.week) }
  scope :mes, ->(fecha) { intersectando(fecha - 1.month, fecha + 1.week + 1.day) }

  scope :con, ->(proyecto, descripcion) { where('proyecto_id = ? AND descripcion = ?', proyecto.id, descripcion) }
end
