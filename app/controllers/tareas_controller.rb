class TareasController < ApplicationController

  def index
    @lunes = traer_lunes
    @tareas = current_usuario.tareas.semana @lunes
    @proyectos = Proyecto.ultimo_mes
    @diferentes_tareas = current_usuario.tareas.mes(@lunes).distinct
    @tarea = Tarea.new
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
    params.permit(:fecha)
  end
end
