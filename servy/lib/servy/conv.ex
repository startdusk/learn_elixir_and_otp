defmodule Servy.Conv do
  # 定义一个结构体，它是一个特殊的map，不能通过key访问如：map[:key]，只能通过属性访问
  defstruct method: "", path: "", params: %{}, resp_body: "", status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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
