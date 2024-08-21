module UniRails
  class App
    class Javascript
      include Singleton

      class << self
        delegate  :imports,
                  :dependencies, :dependencies=,
                  :javascript, :javascript=,
                  to: :instance
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
