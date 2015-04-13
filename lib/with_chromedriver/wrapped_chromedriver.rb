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

    def click(selector)
      element_id = driver_http.post_element(selector).fetch("value").fetch("ELEMENT")
      driver_http.post_click(element_id)
      nil
    end

    private

    attr_reader :driver_http
  end
end
