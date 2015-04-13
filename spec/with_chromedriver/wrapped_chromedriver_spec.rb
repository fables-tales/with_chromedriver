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

    describe "#click" do
      let(:driver_http) {
        double(
          :driver_http,
          :post_element => element_id_result,
          :post_click   => click_result,
        )
      }

      let(:element_id_result) { double(:element, :fetch => value) }
      let(:value) { double(:value, :fetch => element_id) }
      let(:element_id) { double(:element_id) }
      let(:click_result) { double(:click_result) }

      let(:selector) { double(:selector) }

      it "gets the element from posting to the driver http" do
        wrapped_driver.click(selector)
        expect(driver_http).to have_received(:post_element).with(selector)
      end

      it "fetches the value from the response" do
        wrapped_driver.click(selector)
        expect(element_id_result).to have_received(:fetch).with("value")
      end

      it "fetches the ELEMENT key from the value" do
        wrapped_driver.click(selector)
        expect(value).to have_received(:fetch).with("ELEMENT")
      end

      it "posts the click to the driver with the correct element id" do
        wrapped_driver.click(selector)
        expect(driver_http).to have_received(:post_click).with(element_id)
      end

      it "returns nil, indicating no return value" do
        expect(wrapped_driver.click(selector)).to be nil
      end
    end
  end
end
