require 'test_helper'

class HeaderTest < Minitest::Test

  def test_sharp_header
    assert Deadlink::Header::header?("# header")
  end

  def test_not_sharp_header
    refute Deadlink::Header::header?("header")
  end

  def test_under_line_header_hyphen
    assert Deadlink::Header::header?("header", "-----")
  end

  def test_under_line_header_equal
    assert Deadlink::Header::header?("header", "======")
  end

    def test_not_under_line_header_equal
      refute Deadlink::Header::header?("header", "=====+")
    end
end
