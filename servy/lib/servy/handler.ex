defmodule Servy.Handler do
  def handle(request) do
    # 函数式编程 管道
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  # 打印, 这样可以写成一行
  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}
  end

  def route(conv) do
    # elixir每个变量都是不可变的
    # 下面相当于 Map.put(conv, :resp_body, "xxxx")
    # 访问map，map[:resp_body] 如果key不存在返回nil 或 map.resp_body 如果key不存在直接报错
    # %{conv | resp_body: "Bears, Lions, Tigers"}
    route(conv, conv.method, conv.path)
  end

  # elixir 允许函数名相同, 但"参数"不同
  # 如果参数是字符串硬编码, 则会匹配这些字符串
  def route(conv, "GET", "/wildthings") do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    %{conv | status: 200, resp_body: "Teddy, Smoky, Paddington"}
  end

  # 匹配 /bears/{id}
  def route(conv, "GET", "/bears/" <> id) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  # elixir 从上往下执行, 这个函数会被匹配到, 表示某个路径找不到
  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  # 私有函数 用 defp 定义
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts(response)
