class Tarea < ActiveRecord::Base
  belongs_to :proyecto
  belongs_to :usuario

  scope :semana, ->(fecha) { where('desde >= ? AND hasta <= ?', fecha, fecha + 1.week + 1.day) }

  scope :entre, ->(desde, hasta) { where('desde <= ? AND hasta >= ?', desde, hasta) }
end
