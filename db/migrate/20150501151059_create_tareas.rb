class CreateTareas < ActiveRecord::Migration
  def change
    create_table :tareas do |t|

      t.timestamps null: false
      t.datetime "desde", null: false
      t.datetime "hasta", null: false
      t.string "descripcion"
      t.integer "proyecto_id"
      t.integer "usuario_id"
    end
  end
end
