# You can use CoffeeScript in this file: http://coffeescript.org/

#
# Coloreado y cosas de colorear
#

hash_a_color = (hash) ->
  hash = hash.toString(CryptoJS.enc.Hex)
  componentes = [ parseInt(hash.substr(0,2),16), parseInt(hash.substr(2,2),16), parseInt(hash.substr(4,2),16) ]
  max = Math.max(componentes)
  componentes[componentes.indexOf(max)] = max * 4 if max < 50
  return "rgb("+componentes[0]+","+componentes[1]+","+componentes[2]+")"

texto_a_color = (texto) ->
  texto = texto.toString() if typeof(texto) != 'string'
  hash_a_color(CryptoJS.MD5(texto))

colorear_fondo = (elem, texto) ->
  elem.css('background-color', texto_a_color(texto))

colorear_borde = (elem, texto) ->
  elem.css('border',0).css('border-left', '20px ' + texto_a_color(texto) + ' solid')

colorear_lapso = (lapso) ->
  if tiene_datos(lapso)
    colorear_fondo(lapso.children('.proyecto'), lapso.data('proyecto'))
    colorear_fondo(lapso.children('.tarea'), lapso.data('descripcion'))

colorear_boton = (boton) ->
    if boton.data('descripcion')?
      colorear_fondo(boton, boton.data('descripcion'))
    else
      colorear_fondo(boton, boton.data('proyecto'))
    colorear_borde(boton, boton.data('proyecto'))

#
# Interaccion con lapsos y tareas
#

tiene_datos = (lapso) ->
  p = lapso.data('proyecto')
  return p?

copiar_lapso = (desde, hasta) ->
  hasta.data('proyecto', desde.data('proyecto'))
  hasta.data('descripcion', desde.data('descripcion'))

cargar_datos_de_vecino = (lapso) ->
  l = lapso
  while !tiene_datos(lapso) and l.length > 0
    l = l.prev('.lapso')
    copiar_lapso(l, lapso) if tiene_datos(l)

  if !tiene_datos(lapso)
    l = lapso
    while !tiene_datos(lapso) and l.length > 0
      l = l.next('.lapso')
      copiar_lapso(l, lapso) if tiene_datos(l)

activo = (lapso) -> lapso.hasClass('activo')

activar = (lapso) ->
  lapso.addClass('activo') if !activo(lapso)
  cargar_datos_de_vecino(lapso) if !tiene_datos(lapso)
  colorear_lapso(lapso)

tform = () -> $('#tarea-form')

tproyecto = () -> $('#tarea_proyecto')

tdescripcion = () -> $('#tarea_descripcion')

hideform = () -> $('#tarea-form-wrapper').slideUp(160)

showform = () -> $('#tarea-form-wrapper').slideDown(160)

cargar_proyecto = (proyecto) -> tproyecto().val(proyecto)

cargar_descripcion = (descripcion) -> tdescripcion().val(descripcion)

asociar_lapso = (lapso) -> tform().data('lapso', lapso)

cargar_data = (lapso) ->
  if tiene_datos(lapso)
    cargar_proyecto(lapso.data('proyecto'))
    cargar_descripcion(lapso.data('descripcion'))

editar = (lapso) ->
  showform()
  asociar_lapso(lapso)
  cargar_data(lapso)

borrar = (lapso) ->
  lapso.removeData('descripcion')
  lapso.removeData('proyecto')
  lapso.removeClass('activo')
  lapso.children().css('background-color','transparent')
  necesita_sincronizar()

cerrar = () ->
  hideform()
  tform().removeData('lapso')

guardar = () ->
  lapso = tform().data('lapso')
  if lapso.data('proyecto') != tproyecto().val() || lapso.data('descripcion') != tdescripcion().val()
    lapso.data('proyecto', tproyecto().val())
    lapso.data('descripcion', tdescripcion().val())
    colorear_lapso(lapso)
    necesita_sincronizar()

agregar_tarea = (tarea) ->
  diferentes_tareas.push(tarea)
  elem = $.el.span
    class: "tarea-label label"
    "data-descripcion": tarea[0]
    "data-proyecto": tarea[1],
    tarea[0]

  $('#diferentes_tareas').append(elem)
  colorear_boton($('#diferentes_tareas .tarea-label').last())

necesita_sincronizar = () ->
  tb = $('#tarea-save-button')
  tb.removeClass('btn-success').addClass('btn-warning').
    html('<i class="fa fa-save"></i> Guardar') if tb.hasClass('btn-success')

misma_tarea = (tarea, elem) ->
  tarea['proyecto'] == elem.data('proyecto') &&
  tarea['descripcion'] == elem.data('descripcion') &&
  tarea['hasta'] == elem.data('desde')

sincronizar = () ->
  tb = $('#tarea-save-button')
  tb.addClass('spining').html('<i class="fa fa-spinner fa-spin"></i> Guardando')
  tareas = []
  $('.lapso.activo').each (index, elem) =>
    elem = $(elem)
    last = tareas.length - 1
    if tareas[last]? && misma_tarea(tareas[last], elem)
      tareas[last]['hasta'] = elem.data('hasta')
    else
      tareas.push({descripcion: elem.data('descripcion'), proyecto: elem.data('proyecto'), desde: elem.data('desde'), hasta: elem.data('hasta')})

  $.post(
    tb.data('donde')
    { tareas, lunes }
    (data, textStatus, jqXHR) ->
      console.log(data)
      sincronizado()
    'json'
  )

sincronizado = () ->
  $('#tarea-save-button').removeClass('spining btn-warning').addClass('btn-success').html('<i class="fa fa-check-square"> Guardado</i>')

#
# Al iniciar y eventos
#

ready = () ->
  document.oncontextmenu = () -> false

  $('.proyecto, .tarea').on 'mousedown', (e) =>
    $t = $(e.target).parent('.lapso')
    if activo($t)
      editar($t) if e.which == 1
      borrar($t) if e.which > 1
      return false
    else
      activar($t)
      editar($t) if !tiene_datos($t)
      necesita_sincronizar()

  $('.lapso.activo').each (index, elem) => activar($(elem))

  $('.tarea-label').each (index, elem) => colorear_boton($(elem))

  $(document).off 'click', '.tarea-label'
  $(document).on 'click', '.tarea-label', (e) =>
    $t = $(e.target)
    cargar_data($t)
    guardar()
    cerrar()

  $('.proyecto-label').each (index, elem) => colorear_boton($(elem))

  $(document).off 'click', '.proyecto-label'
  $(document).on 'click', '.proyecto-label', (e) => cargar_proyecto($(e.target).data('proyecto'))

  tform().on 'submit', (e) =>
    e.preventDefault()
    e.stopPropagation()
    guardar()
    nueva_tarea = [tdescripcion().val(),tproyecto().val()]
    result = tarea for tarea in diferentes_tareas when tarea[0] == nueva_tarea[0] && tarea[1] == nueva_tarea[1]
    agregar_tarea(nueva_tarea) if ! result?
    cerrar()

  $('#tarea-save-button').on 'click', (e) =>
    $but = $(e.target)
    e.preventDefault()
    if $but.hasClass('btn-warning') && !$but.hasClass('spining')
      sincronizar()

$(document).ready(ready);
$(document).on('page:load', ready);
