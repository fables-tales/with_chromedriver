require "spec_helper"
require "with_chromedriver/wrapped_chromedriver"

module WithChromedriver
  RSpec.describe WrappedChromedriver do
    subject(:wrapped_driver) {
      WrappedChromedriver.new(
        :driver_http => driver_http
      )
    }


    describe "#visit" do
      let(:driver_http) { double(:driver_http, :post_url => post_result) }
      let(:post_result) { double(:post_result) }
      let(:url) { "http://xkcd.com/" }

      it "sends a post_url request to it's driver http instance" do
        wrapped_driver.visit(url)
        expect(driver_http).to have_received(:post_url).with(url)
      end

      it "returns nil" do
        expect(wrapped_driver.visit(url)).to be nil
      end
    end
  end
end
