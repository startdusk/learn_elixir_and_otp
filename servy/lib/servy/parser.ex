defmodule Servy.Parser do
  # 定义别名, 由于别名是Conv, 所以可以这么写
  alias Servy.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: path}
  end
end
