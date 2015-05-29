module TareasHelper
  def fecha_corta(fecha)
    iniciales = %w'D L M X J V S'
    iniciales[fecha.wday] + ' ' + fecha.strftime('%d')
  end

  def desde(dia, lapso)
    dia + (lapso * 20.minutes).seconds
  end

  def hasta(dia, lapso)
    desde(dia, lapso) + 20.minutes
  end
end
