module UniRails
  class App
    class CSS
      include Singleton

      def self.css=(content)
        instance.css = content
      end

      def self.css
        instance.css
      end

      attr_accessor :css
      def initialize
        @css = ""
      end
    end
  end
end
