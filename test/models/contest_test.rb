require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  setup do
    @contest = contests(:default)
  end

  def test_get_epoch
    assert Contest.get_epoch("1970-01-01", "00:00:00") == -Time.now.utc_offset
  end

  def test_get_iso
    assert Contest.get_iso(-Time.now.utc_offset) == ["1970-01-01", "00:00:00"]
  end
end
