$:.unshift File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib langdect]))

require 'rubygems'
require 'curb'
require 'cgi'
require 'json'

class LangDect
  
  attr_reader :error, :lang, :text
  
  def initialize(text_to_detect)
    @error = false
    @lang = nil
    @text = text_to_detect[0..200]
    detect
  end
  def detect
    Curl::Easy.http_get('http://www.google.com/uds/GlangDetect?v=1.0&q=' + CGI.escape(@text)) do |request|
      request.on_failure { @error = true }
      request.on_success { @lang = JSON.load(request.body_str)['responseData'] }
    end
  end
end