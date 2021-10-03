RedmineApp::Application.routes.draw do
  namespace :dynamic_selectable do
  end

  get       '/projects/:project_id/equipments/catalogs', :to => 'equipments#catalogs'
  get       '/projects/:project_id/equipments/global_catalogs', :to => 'catalogs#index'

  get       '/projects/:project_id/equipments/update_vendor_models', :to => 'equipments#update_vendor_models'
  get       '/projects/:project_id/equipments/update_owner_types', :to => 'equipments#update_owner_types'
  get       '/projects/:project_id/equipments/update_owners', :to => 'equipments#update_owners'
  get       '/projects/:project_id/equipments/update_location_types', :to => 'equipments#update_location_types'
  get       '/projects/:project_id/equipments/update_locations', :to => 'equipments#update_locations'

  get       '/projects/:project_id/equipments/attribute_values', :to => 'attribute_values#index'
  get       '/projects/:project_id/equipments/attribute_values/:id/show', :to => 'attribute_values#show'
  get       '/projects/:project_id/equipments/attribute_values/new', :to => 'attribute_values#new'
  post      '/projects/:project_id/equipments/attribute_values/create', :to => 'attribute_values#create'
  get       '/projects/:project_id/equipments/attribute_values/:id/edit', :to => 'attribute_values#edit'
  get       '/projects/:project_id/equipments/attribute_values/:id/copy', :to => 'attribute_values#copy'
  post      '/projects/:project_id/equipments/attribute_values/:id/update', :to => 'attribute_values#update'
  patch     '/projects/:project_id/equipments/attribute_values/:id/update', :to => 'attribute_values#update'
  delete      '/projects/:project_id/equipments/attribute_values/:id/destroy', :to => 'attribute_values#destroy'

  get       '/projects/:project_id/equipments/stores', :to => 'stores#index'
  get       '/projects/:project_id/equipments/stores/:id/show', :to => 'stores#show'
  get       '/projects/:project_id/equipments/stores/new', :to => 'stores#new'
  post      '/projects/:project_id/equipments/stores/create', :to => 'stores#create'
  get       '/projects/:project_id/equipments/stores/:id/copy', :to => 'stores#copy'
  get       '/projects/:project_id/equipments/stores/:id/edit', :to => 'stores#edit'
  post      '/projects/:project_id/equipments/stores/:id/update', :to => 'stores#update'
  patch     '/projects/:project_id/equipments/stores/:id/update', :to => 'stores#update'
  post      '/projects/:project_id/equipments/stores//:id/destroy', :to => 'stores#destroy'
  get       '/projects/:project_id/equipments/stores/:id/update_locations', :to => 'stores#update_locations'
  get       '/projects/:project_id/equipments/stores/update_locations', :to => 'stores#update_locations'
  get       '/projects/:project_id/equipments/stores/:id/update_responsibles', :to => 'stores#update_responsibles'
  get       '/projects/:project_id/equipments/stores/update_responsibles', :to => 'stores#update_responsibles'

  get       '/projects/:project_id/equipments/services', :to => 'services#index'
  get       '/projects/:project_id/equipments/services/:id/show', :to => 'services#show'
  get       '/projects/:project_id/equipments/services/new', :to => 'services#new'
  post      '/projects/:project_id/equipments/services/create', :to => 'services#create'
  get       '/projects/:project_id/equipments/services/:id/copy', :to => 'services#copy'
  get       '/projects/:project_id/equipments/services/:id/edit', :to => 'services#edit'
  post      '/projects/:project_id/equipments/services/:id/update', :to => 'services#update'
  patch     '/projects/:project_id/equipments/services/:id/update', :to => 'services#update'
  post      '/projects/:project_id/equipments/services/:id/destroy', :to => 'services#destroy'

  get       '/projects/:project_id/equipments/service_results', :to => 'service_results#index'
  get       '/projects/:project_id/equipments/service_results/:id/show', :to => 'service_results#show'
  get       '/projects/:project_id/equipments/service_results/new', :to => 'service_results#new'
  post      '/projects/:project_id/equipments/service_results/create', :to => 'service_results#create'
  get       '/projects/:project_id/equipments/service_results/:id/copy', :to => 'service_results#copy'
  get       '/projects/:project_id/equipments/service_results/:id/edit', :to => 'service_results#edit'
  post      '/projects/:project_id/equipments/service_results/:id/update', :to => 'service_results#update'
  patch     '/projects/:project_id/equipments/service_results/:id/update', :to => 'service_results#update'
  post      '/projects/:project_id/equipments/service_results/:id/destroy', :to => 'service_results#destroy'

  get       '/projects/:project_id/equipments/project_organizations', :to => 'project_organizations#index'
  get       '/projects/:project_id/equipments/project_organizations/:id/show', :to => 'project_organizations#show'
  get       '/projects/:project_id/equipments/project_organizations/new', :to => 'project_organizations#new'
  post      '/projects/:project_id/equipments/project_organizations/create', :to => 'project_organizations#create'
  get       '/projects/:project_id/equipments/project_organizations/:id/copy', :to => 'project_organizations#copy'
  get       '/projects/:project_id/equipments/project_organizations/:id/edit', :to => 'project_organizations#edit'
  post      '/projects/:project_id/equipments/project_organizations/:id/update', :to => 'project_organizations#update'
  patch     '/projects/:project_id/equipments/project_organizations/:id/update', :to => 'project_organizations#update'
  post      '/projects/:project_id/equipments/project_organizations/:id/destroy', :to => 'project_organizations#destroy'

  get       '/projects/:project_id/equipments/consignment_notes', :to => 'consignment_notes#index'
  get       '/projects/:project_id/equipments/consignment_notes/:id/show', :to => 'consignment_notes#show'
  get       '/projects/:project_id/equipments/consignment_notes/new', :to => 'consignment_notes#new'
  post      '/projects/:project_id/equipments/consignment_notes/create', :to => 'consignment_notes#create'
  get       '/projects/:project_id/equipments/consignment_notes/:id/copy', :to => 'consignment_notes#copy'
  get       '/projects/:project_id/equipments/consignment_notes/:id/edit', :to => 'consignment_notes#edit'
  post      '/projects/:project_id/equipments/consignment_notes/:id/update', :to => 'consignment_notes#update'
  patch     '/projects/:project_id/equipments/consignment_notes/:id/update', :to => 'consignment_notes#update'
  post      '/projects/:project_id/equipments/consignment_notes/:id/destroy', :to => 'consignment_notes#destroy'

  get       '/projects/:project_id/divisions/divisions', :to => 'divisions#index'
  get       '/projects/:project_id/equipments/divisions/:id/show', :to => 'divisions#show'
  get       '/projects/:project_id/equipments/divisions/new', :to => 'divisions#new'
  post      '/projects/:project_id/equipments/divisions/create', :to => 'divisions#create'
  get       '/projects/:project_id/equipments/divisions/:id/copy', :to => 'divisions#copy'
  get       '/projects/:project_id/equipments/divisions/:id/edit', :to => 'divisions#edit'
  post      '/projects/:project_id/equipments/divisions/:id/update', :to => 'divisions#update'
  patch     '/projects/:project_id/equipments/divisions/:id/update', :to => 'divisions#update'
  post      '/projects/:project_id/equipments/divisions/:id/destroy', :to => 'divisions#destroy'

  get       '/projects/:project_id/equipments/employees', :to => 'employees#index'
  get       '/projects/:project_id/equipments/employees/:id/show', :to => 'employees#show'
  get       '/projects/:project_id/equipments/employees/new', :to => 'employees#new'
  post      '/projects/:project_id/equipments/employees/create', :to => 'employees#create'
  get       '/projects/:project_id/equipments/employees/:id/copy', :to => 'employees#copy'
  get       '/projects/:project_id/equipments/employees/:id/edit', :to => 'employees#edit'
  post      '/projects/:project_id/equipments/employees/:id/update', :to => 'employees#update'
  patch     '/projects/:project_id/equipments/employees/:id/update', :to => 'employees#update'
  post      '/projects/:project_id/equipments/employees/:id/destroy', :to => 'employees#destroy'

  get       '/equipments/catalogs', :to => 'catalogs#index'
  #  get       '/equipments/organizations', :to => 'organizations#index'
  #  get       '/equipments/organizations/show', :to => 'organizations#show'
  #  get       '/equipments/organizations/new', :to => 'organizations#new'
  #  get       '/equipments/organizations/edit', :to => 'organizations#edit'
  #  get       '/equipments/organizations/copy', :to => 'organizations#copy'
  #  post       '/equipments/organizations/destroy', :to => 'organizations#destroy'
  #  post       '/equipments/organizations/update', :to => 'organizations#update'
  #  patch       '/equipments/organizations/update', :to => 'organizations#update'
  #  post       '/equipments/organizations/create', :to => 'organizations#create'
  get       '/equipments/equipment_types', :to => 'equipment_types#index'
  get       '/equipments/equipment_types/:id/show', :to => 'equipment_types#show'
  get       '/equipments/equipment_types/new', :to => 'equipment_types#new'
  get       '/equipments/equipment_types/:id/edit', :to => 'equipment_types#edit'
  get       '/equipments/equipment_types/:id/copy', :to => 'equipment_types#copy'
  post      '/equipments/equipment_types/:id/destroy', :to => 'equipment_types#destroy'
  post      '/equipments/equipment_types/:id/update', :to => 'equipment_types#update'
  patch     '/equipments/equipment_types/:id/update', :to => 'equipment_types#update'
  post      '/equipments/equipment_types/create', :to => 'equipment_types#create'
  get       '/equipments/vendors', :to => 'vendors#index'
  get       '/equipments/vendors/:id/show', :to => 'vendors#show'
  get       '/equipments/vendors/new', :to => 'vendors#new'
  get       '/equipments/vendors/:id/edit', :to => 'vendors#edit'
  get       '/equipments/vendors/:id/copy', :to => 'vendors#copy'
  post      '/equipments/vendors/:id/destroy', :to => 'vendors#destroy'
  post      '/equipments/vendors/:id/update', :to => 'vendors#update'
  patch     '/equipments/vendors/:id/update', :to => 'vendors#update'
  post      '/equipments/vendors/create', :to => 'vendors#create'
  get       '/equipments/vendor_models', :to => 'vendor_models#index'
  get       '/equipments/vendor_models/:id/show', :to => 'vendor_models#show'
  get       '/equipments/vendor_models/new', :to => 'vendor_models#new'
  get       '/equipments/vendor_models/:id/edit', :to => 'vendor_models#edit'
  get       '/equipments/vendor_models/:id/copy', :to => 'vendor_models#copy'
  post      '/equipments/vendor_models/:id/destroy', :to => 'vendor_models#destroy'
  post      '/equipments/vendor_models/:id/update', :to => 'vendor_models#update'
  patch     '/equipments/vendor_models/:id/update', :to => 'vendor_models#update'
  post      '/equipments/vendor_models/create', :to => 'vendor_models#create'
  get       '/equipments/countries', :to => 'countries#index'
  get       '/equipments/countries/:id/show', :to => 'countries#show'
  get       '/equipments/countries/new', :to => 'countries#new'
  get       '/equipments/countries/:id/edit', :to => 'countries#edit'
  get       '/equipments/countries/:id/copy', :to => 'countries#copy'
  post      '/equipments/countries/:id/destroy', :to => 'countries#destroy'
  post      '/equipments/countries/:id/update', :to => 'countries#update'
  patch     '/equipments/countries/:id/update', :to => 'countries#update'
  post      '/equipments/countries/create', :to => 'countries#create'
  get       '/equipments/cities', :to => 'cities#index'
  get       '/equipments/cities/:id/show', :to => 'cities#show'
  get       '/equipments/cities/new', :to => 'cities#new'
  get       '/equipments/cities/:id/edit', :to => 'cities#edit'
  get       '/equipments/cities/:id/copy', :to => 'cities#copy'
  post      '/equipments/cities/:id/destroy', :to => 'cities#destroy'
  post      '/equipments/cities/:id/update', :to => 'cities#update'
  patch     '/equipments/cities/:id/update', :to => 'cities#update'
  post      '/equipments/cities/create', :to => 'cities#create'
  get       '/equipments/streets', :to => 'streets#index'
  get       '/equipments/streets/:id/show', :to => 'streets#show'
  get       '/equipments/streets/new', :to => 'streets#new'
  get       '/equipments/streets/:id/edit', :to => 'streets#edit'
  get       '/equipments/streets/:id/copy', :to => 'streets#copy'
  post      '/equipments/streets/:id/destroy', :to => 'streets#destroy'
  post      '/equipments/streets/:id/update', :to => 'streets#update'
  patch     '/equipments/streets/:id/update', :to => 'streets#update'
  post      '/equipments/streets/create', :to => 'streets#create'
  get       '/equipments/street_types', :to => 'street_types#index'
  get       '/equipments/street_types/:id/show', :to => 'street_types#show'
  get       '/equipments/street_types/new', :to => 'street_types#new'
  get       '/equipments/street_types/:id/edit', :to => 'street_types#edit'
  get       '/equipments/street_types/:id/copy', :to => 'street_types#copy'
  post      '/equipments/street_types/:id/destroy', :to => 'street_types#destroy'
  post      '/equipments/street_types/:id/update', :to => 'street_types#update'
  patch     '/equipments/street_types/:id/update', :to => 'street_types#update'
  post      '/equipments/street_types/create', :to => 'street_types#create'
  get       '/equipments/addresses', :to => 'addresses#index'
  get       '/equipments/addresses/:id/show', :to => 'addresses#show'
  get       '/equipments/addresses/new', :to => 'addresses#new'
  get       '/equipments/addresses/:id/edit', :to => 'addresses#edit'
  get       '/equipments/addresses/:id/copy', :to => 'addresses#copy'
  post      '/equipments/addresses/:id/destroy', :to => 'addresses#destroy'
  post      '/equipments/addresses/:id/update', :to => 'addresses#update'
  patch     '/equipments/addresses/:id/update', :to => 'addresses#update'
  post      '/equipments/addresses/create', :to => 'addresses#create'
  get       '/equipments/floors', :to => 'floors#index'
  get       '/equipments/floors/:id/show', :to => 'floors#show'
  get       '/equipments/floors/new', :to => 'floors#new'
  get       '/equipments/floors/:id/edit', :to => 'floors#edit'
  get       '/equipments/floors/:id/copy', :to => 'floors#copy'
  post      '/equipments/floors/:id/destroy', :to => 'floors#destroy'
  post      '/equipments/floors/:id/update', :to => 'floors#update'
  patch     '/equipments/floors/:id/update', :to => 'floors#update'
  post      '/equipments/floors/create', :to => 'floors#create'
  get       '/equipments/rooms', :to => 'rooms#index'
  get       '/equipments/rooms/:id/show', :to => 'rooms#show'
  get       '/equipments/rooms/new', :to => 'rooms#new'
  get       '/equipments/rooms/:id/edit', :to => 'rooms#edit'
  get       '/equipments/rooms/:id/copy', :to => 'rooms#copy'
  post      '/equipments/rooms/:id/destroy', :to => 'rooms#destroy'
  post      '/equipments/rooms/:id/update', :to => 'rooms#update'
  patch     '/equipments/rooms/:id/update', :to => 'rooms#update'
  post      '/equipments/rooms/create', :to => 'rooms#create'
  get       '/equipments/rooms/:id/update_floors', :to => 'rooms#update_floors'
  get       '/equipments/rooms/update_floors', :to => 'rooms#update_floors'
  get       '/equipments/room_tenants', :to => 'room_tenants#index'
  get       '/equipments/room_tenants/:id/show', :to => 'room_tenants#show'
  get       '/equipments/room_tenants/new', :to => 'room_tenants#new'
  get       '/equipments/room_tenants/:id/edit', :to => 'room_tenants#edit'
  get       '/equipments/room_tenants/:id/copy', :to => 'room_tenants#copy'
  post      '/equipments/room_tenants/:id/destroy', :to => 'room_tenants#destroy'
  post      '/equipments/room_tenants/:id/update', :to => 'room_tenants#update'
  patch     '/equipments/room_tenants/:id/update', :to => 'room_tenants#update'
  post      '/equipments/room_tenants/create', :to => 'room_tenants#create'
  get       '/equipments/attributes', :to => 'attributes#index'
  get       '/equipments/attributes/:id/show', :to => 'attributes#show'
  get       '/equipments/attributes/new', :to => 'attributes#new'
  get       '/equipments/attributes/:id/edit', :to => 'attributes#edit'
  get       '/equipments/attributes/:id/copy', :to => 'attributes#copy'
  post      '/equipments/attributes/:id/destroy', :to => 'attributes#destroy'
  post      '/equipments/attributes/:id/update', :to => 'attributes#update'
  patch     '/equipments/attributes/:id/update', :to => 'attributes#update'
  post      '/equipments/attributes/create', :to => 'attributes#create'
  get       '/equipments/document_types', :to => 'document_types#index'
  get       '/equipments/document_types/:id/show', :to => 'document_types#show'
  get       '/equipments/document_types/new', :to => 'document_types#new'
  get       '/equipments/document_types/:id/edit', :to => 'document_types#edit'
  get       '/equipments/document_types/:id/copy', :to => 'document_types#copy'
  post      '/equipments/document_types/:id/destroy', :to => 'document_types#destroy'
  post      '/equipments/document_types/:id/update', :to => 'document_types#update'
  patch     '/equipments/document_types/:id/update', :to => 'document_types#update'
  post      '/equipments/document_types/create', :to => 'document_types#create'
  get       '/equipments/service_types', :to => 'service_types#index'
  get       '/equipments/service_types/:id/show', :to => 'service_types#show'
  get       '/equipments/service_types/new', :to => 'service_types#new'
  get       '/equipments/service_types/:id/edit', :to => 'service_types#edit'
  get       '/equipments/service_types/:id/copy', :to => 'service_types#copy'
  post      '/equipments/service_types/:id/destroy', :to => 'service_types#destroy'
  post      '/equipments/service_types/:id/update', :to => 'service_types#update'
  patch     '/equipments/service_types/:id/update', :to => 'service_types#update'
  post      '/equipments/service_types/create', :to => 'service_types#create'
  get       '/equipments/service_result_types', :to => 'service_result_types#index'
  get       '/equipments/service_result_types/:id/show', :to => 'service_result_types#show'
  get       '/equipments/service_result_types/new', :to => 'service_result_types#new'
  get       '/equipments/service_result_types/:id/edit', :to => 'service_result_types#edit'
  get       '/equipments/service_result_types/:id/copy', :to => 'service_result_types#copy'
  post      '/equipments/service_result_types/:id/destroy', :to => 'service_result_types#destroy'
  post      '/equipments/service_result_types/:id/update', :to => 'service_result_types#update'
  patch     '/equipments/service_result_types/:id/update', :to => 'service_result_types#update'
  post      '/equipments/service_result_types/create', :to => 'service_result_types#create'

  #get '/rooms/:id/copy', to: 'rooms#copy'
end

resources :equipments_settings, :path => 'admin/equipments' do
  post :backup, on: :collection
  post :restore, on: :collection
  post :save, on: :collection
end

resources :equipments do
  collection do
    get "tagged"
  end
  #resources :catalogs, :only => [:index]
  get :copy, on: :member
  get :update_vendor_models, on: :member, :exclude => [:show]
  get :update_owners, on: :member, :exclude => [:show]
  get :update_locations, on: :member, :exclude => [:show]
  get :update_location_types, on: :member, :exclude => [:show]
  get :update_locations, on: :member, :exclude => [:show]

  resources :catalogs, :only => [:index]

  resources :equipment_types, :only => [:index, :new, :edit, :update]
  resources :equipment_types do
    get :copy, on: :member
  end
  resources :service_types, :only => [:index, :new, :edit, :update]
  resources :service_types do
    get :copy, on: :member
  end
  resources :service_result_types, :only => [:index, :new, :edit, :update]
  resources :service_result_types do
    get :copy, on: :member
  end
  resources :document_types, :only => [:index, :new, :edit, :update]
  resources :document_types do
    get :copy, on: :member
  end
  resources :service_types do
    get :copy, on: :member
  end
  resources :attributes do
    get :copy, on: :member
  end
  resources :attribute_values do
    get :copy, on: :member
    get :update_attributable_objects, on: :member, :exclude => [:show]
  end
  resources :vendors, :only => [:index, :new, :edit, :update]
  resources :vendors do
    get :copy, on: :member
  end
  resources :vendor_models do
    get :copy, on: :member
  end
  resources :countries do
    get :copy, on: :member
  end
  resources :cities do
    get :copy, on: :member
  end
  resources :addresses do
    get :copy, on: :member
  end
  resources :floors do
    get :copy, on: :member
  end
  resources :rooms do
    get :copy, on: :member
    get :update_floors, on: :member, :exclude => [:show]
  end
end

resources :projects do

  resources :equipments, :only => [:index, :show, :new, :edit, :update, :copy]
  resources :equipments do
    collection do
      get "tagged"
    end
    get :copy, on: :member
    get :update_vendor_models, on: :member, :exclude => [:show]
    get :update_owner_types, on: :member, :exclude => [:show]
    get :update_owners, on: :member, :exclude => [:show]
    get :update_location_types, on: :member, :exclude => [:show]
    get :update_locations, on: :member, :exclude => [:show]

    resources :catalogs, :only => [:index]
    resources :employees, :only => [:index, :new, :edit, :update]
    resource :employees do
      get :copy, on: :member
      get :update_floors, on: :member, :exclude => [:show]
    end
    resources :project_organizations, :only => [:index, :new, :edit, :update]
    resource :project_organizations do
      get :copy, on: :member
    end
    resources :consignment_notes, :only => [:index, :new, :edit, :update]
    resource :consignment_notes do
      get :copy, on: :member
    end
    resources :attribute_values, :only => [:index, :new, :edit, :update]
    resource :attribute_values do
      get :copy, on: :member
    end

    resources :services, :only => [:index, :new, :edit, :update]
    resource :services do
      get :copy, on: :member
    end

    resources :stores, :only => [:index, :new, :edit, :update]
    resource :stores do
      get :copy, on: :member
      get :update_responsible, on: :member, :exclude => [:show]
      get :update_locations, on: :member, :exclude => [:show]
    end

    resources :project_organizations, :only => [:index, :new, :edit, :update]
    resource :project_organizations do
      get :copy, on: :member
    end
  end
end
