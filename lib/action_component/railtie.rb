require 'rails/railtie'

module ActionComponent
  class Railtie < Rails::Railtie
    initializer "action_component.add_to_action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include ActionComponent::ActionControllerRendering
      end
    end

    initializer "action_component.add_to_action_view" do
      ActiveSupport.on_load(:action_view) do
        include ActionComponent::ActionViewRendering
      end
    end
  end
end
