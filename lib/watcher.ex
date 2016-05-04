defmodule Watcher do
  use ExFSWatch, dirs: ["lib/koans"]

  def callback(file, events)  do
    if requires_reload?(file, events) do
      reload(file)

      if Tracker.complete? do
        Display.congratulate
        exit(:normal)
      end
    end
  end

  defp requires_reload?(file, events) do
    String.ends_with?(file, [".ex", ".exs"]) and Enum.member?(events, :modified)
  end

  defp reload(file) do
    try do
      file
      |> Code.load_file
      |> Enum.map(&(elem(&1, 0)))
      |> Enum.find(&Runner.koan?/1)
      |> Runner.modules_to_run
      |> Runner.run
    rescue
      e -> Display.show_compile_error(e)
    end
  end
end
