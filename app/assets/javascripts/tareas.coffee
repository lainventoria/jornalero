# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

hash_a_color = (hash) ->
  hash = hash.toString(CryptoJS.enc.Hex)
  componentes = [ parseInt(hash.substr(0,2),16), parseInt(hash.substr(2,2),16), parseInt(hash.substr(4,2),16) ]
  max = Math.max(componentes)
  componentes[componentes.indexOf(max)] = max * 4 if max < 40
  return "rgb("+componentes[0]+","+componentes[1]+","+componentes[2]+")"

texto_a_color = (texto) ->
  hash_a_color(CryptoJS.MD5(texto))

colorear = (lapso) ->
  if tiene_datos(lapso)
    lapso.children('.proyecto').css('background-color', texto_a_color(lapso.data('proyecto')))
    lapso.children('.tarea').css('background-color', texto_a_color(lapso.data('descripcion')))


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

activar = (lapso) ->
  lapso.addClass('activo') if !lapso.hasClass('activo')
  cargar_datos_de_vecino(lapso) if !tiene_datos(lapso)
  colorear(lapso)

ready = () ->

  $('.proyecto, .tarea').on 'click', (e) =>
    $t = $(e.target)
    $t = $t.parent('.lapso') if $t.hasClass('tarea') || $t.hasClass('proyecto')
    activar($t)

  $('.lapso.activo').each (index, elem) =>
    activar($(elem))

$(document).ready(ready);
$(document).on('page:load', ready);
