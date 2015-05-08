require "spec_helper"
require "with_chromedriver"

RSpec.describe WithChromedriver do
  describe ".with_chromedriver" do

    it "evaluates the passed block" do
      expect { |b| WithChromedriver.with_chromedriver(&b) }.to yield_control
    end

    it "passes a WrappedChromeDriver instance to the block" do
      expect { |b|
        WithChromedriver.with_chromedriver(&b)
      }.to yield_with_args(a_kind_of(WithChromedriver::WrappedChromedriver))
    end

    it "allows the user to navigate to a page with the chromedriver instance and evaluate a script" do
      result = WithChromedriver.with_chromedriver do |driver|
        driver.visit("http://xkcd.com/")
        driver.evaluate_script("return window.location.href");
      end

      expect(result).to eq("http://xkcd.com/")
    end

    it "allows users to click elements" do
      result = WithChromedriver.with_chromedriver do |driver|
        driver.visit("http://xkcd.com/")
        driver.click("#middleContainer > ul:nth-child(4) > li:nth-child(1) > a")
        sleep(1)
        driver.evaluate_script("return window.location.href");
      end

      expect(result).to eq("http://xkcd.com/1/")
    end

    it "does not leak chrome processes" do
      expect {
        WithChromedriver.with_chromedriver {}
        sleep(0.1)
      }.to_not change { number_of_chrome_processes }
    end

    def number_of_chrome_processes
      `ps aux | grep -i 'chromedriver --port' | grep -vc "grep"`
    end
  end
end
