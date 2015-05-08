require "open3"
require "faraday"
require "json"

module WithChromedriver
  class SessionHTTP
    def initialize
      start_chromedriver_process
      create_faraday_session
    end

    def end_session
      conn.delete("#{session_url}/window")
      release_port
    end

    def post(url, params)
      conn.post("#{session_url}#{url}", JSON.dump(params), {"Content-Type" => "application/json"}).tap {|x|
        p x
      }
    end

    private

    attr_reader :port, :conn, :session_id

    def session_url
      "/session/#{session_id}"
    end

    def start_chromedriver_process
      acquire_port
    end

    def acquire_port
      result = {}
      until result.fetch("success", false)
        result = JSON.parse(http_connection("http://localhost:8883").post("/acquire", {:_ => "123"}).body)
      end

      @port = result.fetch("port").to_i
    end

    def release_port
      result = http_connection("http://localhost:8883").post("/release", {:port => port})
      raise "failed to release port" unless JSON.parse(result.body).fetch("success")
    end

    def create_faraday_session
      @conn = http_connection("http://localhost:#{port}")
      response = conn.post("/session", capabilites_param)
      @session_id = JSON.parse(response.body).fetch("sessionId")
    end

    def capabilites_param
      JSON.dump(
        "desiredCapabilities" => capabilities,
        "requiredCapabilities" => capabilities,
      )
    end

    def capabilities
      {
        "javascriptEnabled" => true,
      }
    end

    def http_connection(url)
      Faraday.new(:url => url) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.request :url_encoded
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
