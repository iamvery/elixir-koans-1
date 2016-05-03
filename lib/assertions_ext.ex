defmodule AssertionsExt do
  defmacro assert_receive(expr) do
    expr = Macro.postwalk(expr, &pin/1)
    quote do
      ExUnit.Assertions.assert_receive(unquote(expr))
    end
  end

  defp pin({:answer, _, _} = expr) do
    quote do
      ^unquote(expr)
    end
  end
  defp pin(expr), do: expr
end
