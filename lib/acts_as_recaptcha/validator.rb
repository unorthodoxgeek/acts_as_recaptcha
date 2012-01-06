require "net/http"
require "uri"

module ActsAsRecaptcha
  module Validator
    def self.validate_recaptcha(challenge, response, remoteip, private_key = ENV['RECAPTCHA_PRIVATE_KEY'] )
      uri = URI.parse("http://www.google.com/recaptcha/api/verify")
      params = {
        :privatekey => private_key,
        :challenge => challenge,
        :response => response,
        :remoteip => remoteip
      }

      Net::HTTP.post_form(uri, params).body.split("\n")
    end
  end
end
