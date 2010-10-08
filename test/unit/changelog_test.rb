require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
# require 'test_helper'

class ChangelogTest < ActiveSupport::TestCase
  
  test "add an entry to changelog" do
    bar = Changelog.add("foouser","took apart the radiator")
    assert bar.user = "foouser"
    assert bar.text = "took apart the radiator"
    assert bar.date.day == Date.today.day
  end

end
