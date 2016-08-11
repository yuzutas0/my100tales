# override to customize the tag

# action_view
module ActionView
  # helpers
  module Helpers
    # form_tag_helper
    module FormTagHelper
      def utf8_enforcer_tag
        ''.html_safe
      end
    end
  end
end
