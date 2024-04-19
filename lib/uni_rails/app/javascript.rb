module UniRails
  class App
    class Javascript
      include Singleton

      def self.imports
        instance.imports
      end

      def self.default_dependencies=(dependencies)
        instance.default_dependencies = dependencies
      end

      def self.dependencies=(dependencies)
        instance.dependencies = instance.default_dependencies.merge(dependencies)
      end

      def self.javascript
        instance.javascript
      end

      def self.javascript=(content)
        instance.javascript = content
      end

      attr_accessor :dependencies, :default_dependencies, :javascript
      def initialize
        @default_dependencies = {}
        @dependencies = {}
        @javascript = ""
      end

      def imports
        { imports: dependencies }
      end
    end
  end
end
