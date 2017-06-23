defmodule Meetup.Handler do

  import Meetup.Plugins, only: [log: 1, rewrite_path: 1]

  @about_path Path.expand("../pages/", __DIR__) |> Path.join("about.html")

  def handle(request) do
    request
    |> parse
    |> log    
    |> rewrite_path
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request 
      |> String.split("\n") 
      |> List.first 
      |> String.split(" ")
    %{method: method, status: "", path: path, resp_body: ""}
  end

  def route(%{path: "/meetups"} = conn), do:
      %{conn | resp_body: "shenzhen meetup, shanghai elixir"}
  def route(%{path: "/speakers/" <> id} = conn), do:
      %{conn | resp_body: "speaker #{id}"}      
  def route(%{path: "/about"} = conn) do
    @about_path
    |> File.read
    |> handle_file(conn)

    # case File.read(file) do
    #   {:ok, content} -> 
    #     %{ conn | status: 200, resp_body: content}
    #   {:error, :enoent} ->
    #     %{ conn | status: 404, resp_body: "file not exists"}
    #   _ ->
    #     %{ conn | status: 500, resp_body: "Not Found"}
    # end
    
  end
  def route(conn), do: %{conn | status: 403} 
  
  def handle_file({:ok, content}, conn) do
    %{ conn | status: 200, resp_body: content}
  end
  def handle_file({:error, :enoent}, conn) do
    %{ conn | status: 404, resp_body: "file not exists"}
  end
  def handle_file(_, conn) do
    %{ conn | status: 500, resp_body: "Not Found"}
  end



  def format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{status_reason(conn.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conn.resp_body)}

    #{conn.resp_body}
    """
  end

  # defp status_reason(code) do
  #   %{
  #     200 => "OK",
  #     201 => "Created",
  #     401 => "Unauthorized",
  #     403 => "Forbidden",
  #     404 => "Not Found",
  #     500 => "Internal Server Error"
  #   }[code]
  # end  
  def status_reason(200), do: "OK"
  def status_reason(403), do: "Forbidden"
  def status_reason(404), do: "Not Found"
  def status_reason(500), do: "Internal Server Error"
  def status_reason(_), do: nil  
end


request = """
GET /meetups HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Meetup.Handler.handle(request)

request = """
GET /shenzhen HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Meetup.Handler.handle(request)

request = """
GET /elixians HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Meetup.Handler.handle(request)

request = """
GET /speakers/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Meetup.Handler.handle(request)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Meetup.Handler.handle(request)

