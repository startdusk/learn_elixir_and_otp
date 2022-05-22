defmodule Servy.Handler do
  def handle(request) do
    # 函数式编程 管道
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    # elixir每个变量都是不可变的
    # 下面相当于 Map.put(conv, :resp_body, "xxxx")
    # 访问map，map[:resp_body] 如果key不存在返回nil 或 map.resp_body 如果key不存在直接报错
    %{conv | resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts(response)
