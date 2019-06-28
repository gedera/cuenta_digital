module CuentaDigital
  module Exception
    class  Exception < ::StandardError
      attr_accessor :backtrace

      def initialize(msg, backtrace)
        @backtrace = backtrace
        super(msg)
      end
    end

    class MissingAttributes < Exception
      def initialize(attributes, backtrace = nil)
        @backtrace = backtrace
        super("Missing attributes: #{attributes}", backtrace)
      end
    end

    class InvalidValueAttribute < Exception
      def initialize(attribute, backtrace = nil)
        @backtrace = backtrace
        super("Invalid value for: #{attribute}", backtrace)
      end
    end

    class InvalidFormat < Exception
      def initialize(attribute, backtrace = nil)
        @backtrace = backtrace
        super("Invalid format for: #{attribute}", backtrace)
      end
    end
  end
end
