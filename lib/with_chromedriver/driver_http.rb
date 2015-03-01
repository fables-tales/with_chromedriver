require "json"

module WithChromedriver
  class DriverHTTP
    def initialize(args)
      @session_http = args.fetch(:session_http)
    end

    def post_url(url)
      session_http.post("/url", {"url" => url})
      nil
    end

    def post_execute(script)
      param = {
        "script" => script,
        "args" => [],
      }
      p param
      r = session_http.post("/execute", param)
      p "------------------"
      p r
      p "------------------"
      p r.status
      p "------------------"
      p r.body
      p "------------------"
      JSON.parse(r.body)
    end

    private

    attr_reader :session_http
  end
end
