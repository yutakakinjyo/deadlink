$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'deadlink'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'minitest/autorun'
