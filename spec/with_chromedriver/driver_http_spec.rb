require "spec_helper"
require "with_chromedriver/driver_http"

module WithChromedriver
  RSpec.describe DriverHTTP do
    subject(:driver_http) { DriverHTTP.new(:session_http => session_http) }

    let(:session_http) { double(:session_http, :post => post_result) }

    let(:post_result) { double }
    let(:url) { "http://xkcd.com" }

    describe "#post_url" do
      it "sends a json encoded post request to the session http" do
        driver_http.post_url(url)
        expect(session_http).to have_received(:post).with(
          "/url",
          {"url" => url}
        )
      end

      it "returns nil" do
        expect(driver_http.post_url(url)).to be nil
      end
    end
  end
end
