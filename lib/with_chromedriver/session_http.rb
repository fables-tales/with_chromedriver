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

      Process.kill("TERM", wait_thread.pid)
      sleep(0.1)
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

    def wait_thread
      @chromedriver_process_pipes[3]
    end

    def start_chromedriver_process
      @port = 50000 + rand(10000)
      @chromedriver_process_pipes = Open3.popen3("chromedriver", "--port=#{port}")
      sleep(0.1)
    end

    def create_faraday_session
      @conn = Faraday.new(:url => "http://localhost:#{port}") do |faraday|
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.response :logger                  # log requests to STDOUT
      end

      response = conn.post("/session", capabilites_param)

      p response

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
  end
end
