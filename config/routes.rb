Rails.application.routes.draw do

  devise_for :usuarios

  authenticated :usuario do
    root "tareas#index"
  end

  unauthenticated do
    devise_scope :usuario do
      root "devise/sessions#new", as: 'unauthenticated'
    end
  end

  resources :proyectos do
    collection do
      get :autocomplete_proyecto_nombre
    end
  end

  resources :tareas do
    collection do
      get :autocomplete_tarea_descripcion
    end
  end

  # Todas estas acciones necesitan que el deudor se autentique antes
#  authenticate :deudor do
#   resources :deudas do
#      resources :planes_de_pago, only: [ :new, :create ]
#      resources :cuotas, only: [ :index, :show ] do
#        post :confirmar_pago, to: 'cuotas#confirmar_pago'
#      end
#    end
#  end
end
