module RailsCom::ActionDispatch
  module Mapper

    def set_member_mappings_for_resource
      if parent_resource.actions.include?(:index)
        collection do
          post :preview
        end
      end
      if parent_resource.actions.include?(:new)
        new do
          post :new
        end
      end
      if parent_resource.actions.include?(:create)
        collection do
          post :create_refresh
        end
      end
      member do
        post :actions
        if parent_resource.actions.include?(:show) && parent_resource.actions.include?(:index)
          post :show
        end
        if parent_resource.actions.include?(:edit)
          post :edit
          post :inline
        end
        if parent_resource.actions.include?(:update)
          patch :refresh
        end
      end
      super
    end

  end
end


ActionDispatch::Routing::Mapper.prepend RailsCom::ActionDispatch::Mapper
