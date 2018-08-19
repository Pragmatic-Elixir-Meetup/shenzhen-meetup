# Dataloader |> uncover |> intro

### Example Repo

<https://github.com/Pragmatic-Elixir-Meetup/dataloder-intro>

### Tips

#### Basic usage of Dataloader's Ecto source

1. Setup Dataloader for Absinthe

    ```elixir
    defmodule BlogWeb.Schema do
      use Absinthe.Schema

      def context(ctx) do
        dataloader = Dataloader.new()
        Map.put(ctx, :loader, dataloader)
      end

      def plugins do
        [Absinthe.Middleware.Dataloader || Absinthe.Plugin.defaults()]
      end
    end
    ```

2. Define dataloader ecto source

    ```elixir
    defmodule BlogWeb.Dataloader.Database do
      def new do
        Dataloader.Ecto.new(Blog.Repo, query: &query/2)
      end

      def query(queryable, _params) do
        queryable
      end
    end
    ```

3. Load data with dataloader

    ```elixir
    defmodule BlogWeb.Schema do
      use Absinthe.Schema

      import Absinthe.Resolution.Helpers, only: [dataloader: 1]

      def context(ctx) do
        dataloader =
          Dataloader.new()
          |> Dataloader.add_source(:db, BlogWeb.Dataloader.Database.new())

        Map.put(ctx, :loader, dataloader)
      end

      # ...

      object :post do
        # ...
        field :user, non_null(:user), resolve: dataloader(:db)
        field :comments, list_of(:comment), resolve: dataloader(:db)
        # ...
      end
    end
    ```

#### Load aggregated data with dataloader's KV source

1. Define a customized KV source
    ```elixir
    defmodule BlogWeb.Dataloader.CommentsCount do
      import Ecto.Query
      def new(), do: Dataloader.KV.new(&load/2)

      def load(_batch_key, posts) do
        post_ids = Enum.map(posts, & &1.id)
        comments_counts = comments_counts(post_ids)

        Enum.reduce(posts, %{}, fn post, acc ->
          Map.put(acc, post, Map.get(comments_counts, post.id) || 0)
        end)
      end

      def comments_counts(post_ids) do
        query = from c in Blog.Comment,
          where: c.post_id in ^post_ids,
          group_by: c.post_id,
          select: {c.post_id, fragment("count(*)")}

        query
        |> Blog.Repo.all()
        |> Map.new()  # %{ 1 => 4, 2 => 1 }
      end
    end
    ```

2. Register the source

    ```elixir
    defmodule BlogWeb.Schema do
      use Absinthe.Schema

      def context(ctx) do
        dataloader =
          Dataloader.new()
          |> Dataloader.add_source(:comments_count,
             BlogWeb.Dataloader.CommentsCount.new())
        Map.put(ctx, :loader, dataloader)
      end
    end
    ```

3. Load data with dataloader

    ```elixir
    field :comments_count, :integer do
      resolve fn %{id: post_id}, _, %{context: %{loader: loader}} ->
        loader
        |> Dataloader.load(:comments_count, :post, post)
        |> on_load(fn loader ->
          count = Dataloader.get(loader, :comments_count, :post, post) || 0
          {:ok, count}
        end)
      end
    end
    ```

    Or use the built-in `dataloader` helper

    ```elixir

    import Absinthe.Resolution.Helpers, only: [dataloader: 1]

    object :post do
      field :comments_count, non_null(:integer), resolve: dataloader(:comments_count)
    end
    ```
