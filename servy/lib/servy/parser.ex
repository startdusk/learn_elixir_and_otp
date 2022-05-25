defmodule Servy.Parser do
  # 定义别名, 由于别名是Conv, 所以可以这么写
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | _] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")

    params = parse_params(params_string)

    %Conv{
      method: method,
      path: path,
      params: params
    }
  end

  def parse_params(params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end
end
