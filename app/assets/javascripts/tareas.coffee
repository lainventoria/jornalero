# You can use CoffeeScript in this file: http://coffeescript.org/

hash_a_color = (hash) ->
  hash = hash.toString(CryptoJS.enc.Hex)
  componentes = [ parseInt(hash.substr(0,2),16), parseInt(hash.substr(2,2),16), parseInt(hash.substr(4,2),16) ]
  max = Math.max(componentes)
  componentes[componentes.indexOf(max)] = max * 4 if max < 40
  return "rgb("+componentes[0]+","+componentes[1]+","+componentes[2]+")"

texto_a_color = (texto) ->
  hash_a_color(CryptoJS.MD5(texto))

colorear_fondo = (elem, texto) ->
  elem.css('background-color', texto_a_color(texto))

colorear_borde = (elem, texto) ->
  elem.css('border-color', texto_a_color(texto))

colorear_lapso = (lapso) ->
  if tiene_datos(lapso)
    colorear_fondo(lapso.children('.proyecto'), lapso.data('proyecto'))
    colorear_fondo(lapso.children('.tarea'), lapso.data('descripcion'))

tiene_datos = (lapso) ->
  p = lapso.data('proyecto')
  return p?

cargar_datos_de_vecino = (lapso) ->
  l = lapso
  while !tiene_datos(lapso) and l.length > 0
    l = l.prev('.lapso')
    if tiene_datos(l)
      lapso.data('proyecto', l.data('proyecto'))
      lapso.data('descripcion', l.data('descripcion'))

  if !tiene_datos(lapso)
    l = lapso
    while !tiene_datos(lapso) and l.length > 0
      l = l.next('.lapso')
      if tiene_datos(l)
        lapso.data('proyecto', l.data('proyecto'))
        lapso.data('descripcion', l.data('descripcion'))


activo = (lapso) ->
  lapso.hasClass('activo')

activar = (lapso) ->
  lapso.addClass('activo') if !activo(lapso)
  cargar_datos_de_vecino(lapso) if !tiene_datos(lapso)
  colorear_lapso(lapso)

editar = (lapso) ->
  $('#tarea-form').show()
  $('#tarea-form').data('lapso', lapso)

ready = () ->

  $('.proyecto, .tarea').on 'click', (e) =>
    $t = $(e.target)
    $t = $t.parent('.lapso') if $t.hasClass('tarea') || $t.hasClass('proyecto')
    if activo($t)
      editar($t)
      activar($t)
    else
      activar($t)

  $('.lapso.activo').each (index, elem) =>
    activar($(elem))

  $('.tarea-btn').each (index, elem) =>
    colorear_fondo($(elem), $(elem).data('descripcion'))
    colorear_borde($(elem), $(elem).data('proyecto'))

  $('.proyecto-btn').each (index, elem) =>
    colorear_fondo($(elem), $(elem).data('proyecto'))
    colorear_borde($(elem), $(elem).data('proyecto'))

$(document).ready(ready);
$(document).on('page:load', ready);
