module RailsCom::ActionDispatch
  module Mapper

    def set_member_mappings_for_resource
      new do
        post :new
      end if parent_resource.actions.include?(:new)
      member do
        post :actions
        post :show if parent_resource.actions.include?(:show) && parent_resource.actions.include?(:index)
        if parent_resource.actions.include?(:edit)
          post :edit
          post :edit_inline
        end
      end
      super
    end

  end
end


ActionDispatch::Routing::Mapper.prepend RailsCom::ActionDispatch::Mapper
