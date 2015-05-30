class ProyectosController < ApplicationController
  autocomplete :proyecto, :nombre, extra_data: [:id]
end
