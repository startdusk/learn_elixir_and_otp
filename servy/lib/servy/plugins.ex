defmodule Servy.Plugins do
  @doc """
  Logs 404 requests
  """
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  # 必须定义可以匹配全部的函数
  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  # 打印, 这样可以写成一行
  def log(conv), do: IO.inspect(conv)
end
