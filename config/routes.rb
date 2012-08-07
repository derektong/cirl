Cirl::Application.routes.draw do
  
  match '/contact', :to => 'static_pages#contact'
  match '/about/cirl', :to => 'static_pages#about_cirl'
  match '/about/advisory', :to => 'static_pages#about_advisory'
  match '/about/diana', :to => 'static_pages#about_diana'
  match '/about/coram', :to => 'static_pages#about_coram'
  match '/help', :to => 'static_pages#help'
  match '/signup', :to => 'users#new'
  match '/signin', :to =>'sessions#new'
  match '/signout', :to => 'sessions#destroy', via: :delete
  match '/courts/for_jurisdiction_id/:id' => 'courts#for_jurisdiction_id'
  match '/document_types/for_publisher_id/:id' => 'document_types#for_publisher_id'

  # miscellaneous admin stuff
  match '/admin', :to => 'admin#index'
  match '/admin/reset_database', :to => 'admin#reset_database'
  match '/admin/restore_quotes', :to => 'admin#restore_quotes'
  match '/admin/restore_country_origins', :to => 'admin#restore_country_origins'
  match '/admin/restore_courts', :to => 'admin#restore_courts'
  match '/admin/restore_keywords', :to => 'admin#restore_keywords'
  match '/admin/restore_document_types', :to => 'admin#restore_document_types'
  match '/admin/restore_organisations', :to => 'admin#restore_organisations'

  scope "/admin" do
    resources :quotes, only: [:create, :destroy, :index] 
    resources :jurisdictions
    resources :country_origins 
    resources :courts 
    resources :publishers
    resources :document_types
    resources :organisations
    resources :child_topics 
    resources :child_links, only: [:create, :destroy]
    resources :refugee_topics 
    resources :refugee_links, only: [:create, :destroy]
    resources :process_topics 
    resources :process_links, only: [:create, :destroy]
    resources :keywords do
      resources :aliases
    end
  end

  resources :users do
    member do
      get 'toggle_admin'
      get 'cases'
      get 'case_searches'
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

  match '/keywords/:process_ids/:child_ids/:refugee_ids' => 'keywords#refresh_keywords'
  resources :cases do
    member do
      get 'download'
      get 'delete'
      get 'save'
      get 'unsave'
    end

    collection do
      get 'import'
    end
  end

  resources :legal_briefs do
    member do
      get 'download'
      get 'delete'
      get 'save'
      get 'unsave'
    end
  end

  resources :case_searches do
    collection do
      get 'results'
    end

    member do
      get 'save'
    end
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
root :to => 'static_pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
