defmodule Servy.Plugins do
  alias Servy.Conv

  @doc """
  Logs 404 requests
  """
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  # 必须定义可以匹配全部的函数
  # %Conv{} = conv 表示不关心数据内容, 只关心数据类型
  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  # 打印, 这样可以写成一行
  def log(%Conv{} = conv), do: IO.inspect(conv)
end
