defmodule Meetup.Plugins do
  def rewrite_path(%{path: "/elixians"} = conn) do
    %{ conn | path: "/meetups"}
  end

  def rewrite_path(conn), do: conn

  def log(conn) do
    IO.inspect conn
  end  
end

