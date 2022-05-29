defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
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
      |> Enum.map(&bear_item/1)
      |> Enum.join()

    %{
      conv
      | status: 200,
        resp_body: "<ul>#{items}</ul>"
    }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
  end

  def create(conv, params) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{params["type"]} bear named #{params["name"]}"
    }
  end
end
