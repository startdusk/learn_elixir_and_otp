[Elixir 介绍](https://juejin.cn/post/6844903669163360270)

# 运行

```elixir
$ elixir lib/servy.ex(单文件)
```

# 加载并编译所有模块(有新文件或新模块的时候)

```elixir
$ iex -S mix
```

# 在 iex 下重新编译模块

```elixir
$ r Servy.Handler
```

# 在 iex 下直接重新新编译整个项目(有新增模块, 新增文件的情况下, 需要更新 iex 的 session 才能知道有这个模块)

```elixir
$ recompile()
```
