module UniRails
  module Helpers
    module JavascriptHelper
      def mono_rails_import_map_tag
        content_tag(:script, type: 'importmap') do
          raw App::Javascript.imports.to_json
        end
      end

      def mono_rails_javascript_script
        content_tag(:script, type: 'module') do
          raw App::Javascript.javascript
        end
      end
    end
  end
end
