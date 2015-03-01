module WithChromedriver
  class WrappedChromedriver
    def initialize(args)
      @driver_http = args.fetch(:driver_http)
    end

    def visit(url)
      driver_http.post_url(url)
      nil
    end

    def evaluate_script(script)
      driver_http.post_execute(script).fetch("value")
    end

    private

    attr_reader :driver_http
  end
end
