# override to customize the tag
module ActionView
  module Helpers
    module FormTagHelper
      def utf8_enforcer_tag
        ''.html_safe
      end
    end
  end
end
