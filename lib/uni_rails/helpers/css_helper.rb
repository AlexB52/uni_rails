module UniRails
  module Helpers
    module CSSHelper
      def mono_rails_css_stylesheet
        content_tag(:style) do
          raw App::CSS.css
        end
      end
    end
  end
end
