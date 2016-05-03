defmodule AssertionsExtTest do
  use ExUnit.Case, async: true
  require AssertionsExt

  test "automatically pins answer so that it can't be rebound" do
    answer = :lol
    send self, :wat

    assert_raise ExUnit.AssertionError, fn ->
      AssertionsExt.assert_receive answer
    end
  end

  test "answer is pinned when nested in structured data" do
    answer = :lol
    send self, {:msg, :wat}

    assert_raise ExUnit.AssertionError, fn ->
      AssertionsExt.assert_receive {:msg, answer}
    end
  end

  test "ExUnit's assert_receive leaks into unpinned variables" do
    answer = :lol
    send self, :wat

    ExUnit.Assertions.assert_receive answer
    assert answer == :wat
  end
end
