defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  alias Servy.Conv

  # 定义常量
  @pages_path Path.expand("../../pages", __DIR__)

  # 导入外部模块, only表示只导入特定的函数,变量等, 1表示该函数的参数数量为1个
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    # 函数式编程 管道
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  # def route(conv) do
  #   # elixir每个变量都是不可变的
  #   # 下面相当于 Map.put(conv, :resp_body, "xxxx")
  #   # 访问map，map[:resp_body] 如果key不存在返回nil 或 map.resp_body 如果key不存在直接报错
  #   # %{conv | resp_body: "Bears, Lions, Tigers"}
  #   route(conv, conv.method, conv.path)
  # end

  # elixir 允许函数名相同, 但"参数"不同
  # 如果参数是字符串硬编码, 则会匹配这些字符串
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smoky, Paddington"}
  end

  # 匹配 /bears/{id}
  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  # 等价于上面
  # def route(%{method: "GET", path: "/about"} = conv) do
  #   # pages_path = Path.expand("../../pages", __DIR__)
  #   # file = Path.join(pages_path, "about.html")
  #   # 相当于下面
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   # case匹配和顺序相关, reason相当于匹配所有错误
  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found"}

  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  # elixir 从上往下执行, 这个函数会被匹配到, 表示某个路径找不到
  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts(response)

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

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)

IO.puts(response)
