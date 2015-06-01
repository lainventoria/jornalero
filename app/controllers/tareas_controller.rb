class TareasController < ApplicationController

  def index
    @lunes = traer_lunes
    @tareas = current_usuario.tareas.semana @lunes
    @proyectos = Proyecto.ultimo_mes
    @diferentes_tareas = current_usuario.tareas.mes(@lunes).distinct.joins(:proyecto).pluck(:descripcion, "proyectos.nombre")
    @tarea = Tarea.new
  end

  def create
    esta_semana.destroy_all
    unless params[:tareas].nil?
      params[:tareas].each do |index, tarea|
        proyecto = Proyecto.find_or_create_by({nombre: tarea[:proyecto]})
        current_usuario.tareas.create({proyecto: proyecto, descripcion: tarea[:descripcion], desde: tarea[:desde], hasta: tarea[:hasta]})
      end
    end

    cuenta = if params[:tareas].nil? then 0 else params[:tareas].count end
    if esta_semana.count == cuenta
      render status: :created, json: esta_semana
    else
      render status: :internal_server_error, json: esta_semana
    end
  end

  def traer_lunes
    lunes_proximo_anterior traer_fecha
  end

  def traer_fecha
    fecha = tarea_params[:fecha]
    if fecha.nil?
      DateTime.now
    else
      fecha.to_datetime
    end
  end

  def lunes_proximo_anterior(fecha)
    fecha - (fecha.wday + 6).modulo(7)
  end

  def tarea_params
    params.permit(:fecha, :tareas, :lunes)
  end

  def esta_semana
    current_usuario.tareas.semana(params[:lunes].to_datetime)
  end
end
