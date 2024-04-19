module UniRails
  class App
    class CSS
      include Singleton

      class << self
        delegate :css, :css=, to: :instance
      end

      attr_accessor :css
      def initialize
        @css = ""
      end
    end
  end
end
