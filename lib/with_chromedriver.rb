require "with_chromedriver/version"
require "with_chromedriver/wrapped_chromedriver"
require "with_chromedriver/driver_http"
require "with_chromedriver/session_http"

module WithChromedriver
  def self.with_chromedriver(&block)
    session = SessionHTTP.new
    begin
      result = block.call(make_wrapped_chromedriver(session))
    ensure
      session.end_session
    end
  end

  private

  def self.make_wrapped_chromedriver(session_http)
    WrappedChromedriver.new(
      :driver_http => make_driver_http(session_http),
    )
  end

  def self.make_driver_http(session_http)
    DriverHTTP.new(
      :session_http => session_http,
    )
  end
end
