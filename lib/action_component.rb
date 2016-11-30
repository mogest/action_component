module ActionComponent
end

require 'action_component/version'

# Rails integration

require 'action_component/action_controller_rendering'
require 'action_component/action_view_rendering'
require 'action_component/railtie'

# Base dependencies

require 'action_component/callbacks'
require 'action_component/constraints'
require 'action_component/elements'
require 'action_component/element_builder'

# Base

require 'action_component/base'
