module UniRails
  class App
    class Views
      include Singleton

      DEFAULT_LAYOUT = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>Template</title>
            <meta name="viewport" content="width=device-width,initial-scale=1">
            <%= csrf_meta_tags %>
            <%= csp_meta_tag %>

            <%= mono_rails_css_stylesheet %>
            <%= mono_rails_import_map_tag %>
            <%= mono_rails_javascript_script %>
          </head>

          <body>
            <%= yield %>
          </body>
        </html>
      HTML

      attr_accessor :views
      def initialize
        @views = { 'layouts/application.html.erb' => DEFAULT_LAYOUT }
      end

      def self.view_paths
        [ActionView::FixtureResolver.new(instance.views)]
      end
    end
  end
end
