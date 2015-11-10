$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'deadlink'
require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
