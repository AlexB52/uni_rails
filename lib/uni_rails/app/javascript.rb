module UniRails
  class App
    class Javascript
      include Singleton

      def self.imports
        instance.imports
      end

      def self.dependencies=(deps)
        instance.dependencies.merge!(deps)
      end

      def self.javascript
        instance.javascript
      end

      def self.javascript=(content)
        instance.javascript = content
      end

      attr_accessor :dependencies, :javascript
      def initialize
        @dependencies = {}
        @javascript = ""
      end

      def imports
        { imports: dependencies }
      end
    end
  end
end
