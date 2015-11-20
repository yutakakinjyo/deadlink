$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'deadlink'

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!
