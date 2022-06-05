defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../templates", __DIR__)

  def index(conv) do
    bears =
      Wildthings.list_bears()
      # |> Enum.filter(fn b -> Bear.is_grizzly(b) end)
      # 等价于下面, 提升函数为匿名函数
      # |> Enum.filter(&Bear.is_grizzly(&1))
      # 等价于下面，使用数字代表参数个数
      |> Enum.filter(&Bear.is_grizzly/1)
      # |> Enum.sort(fn b1, b2 -> Bear.order_asc_by_name(b1, b2) end)
      # 等价于下面, 提升函数为匿名函数
      # |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, params) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{params["type"]} bear named #{params["name"]}"
    }
  end

  # \\ [] 等价于bingdings为空，则为空列表(默认参数)
  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end
end
