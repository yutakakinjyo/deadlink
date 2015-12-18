require 'test_helper'

class HeaderTest < Minitest::Test
  def test_sharp_header
    assert Deadlink::Header::header?("# header")
  end
  
end
