require 'test_helper'

class TestTest < ActiveSupport::TestCase
  def setup
    @test = Test.new(name: "Test", theme: "дроби",
                     subtheme: "деление дробей")
  end

  test "should be valid" do
    assert @test.valid?
  end

  test "name should be present" do
    @test.name = "     "
    assert_not @test.valid?
  end

  test "theme should be present" do
    @test.theme = "     "
    assert_not @test.valid?
  end

  test "subtheme should be present" do
    @test.subtheme = "     "
    assert_not @test.valid?
  end
end
