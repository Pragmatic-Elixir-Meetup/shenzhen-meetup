
response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

"""


# 1. GET /meetups
request = """
GET /meetups HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Meetup.Handler.handle(request)

# 2. GET /speakers, another path
request = """
GET /speakers HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# 3. GET /shenzhen, a path not exists
request = """
GET /shenzhen HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = """
HTTP/1.1 403 Forbidden
Content-Type: text/html
Content-Length: 20

Path Not Found
"""

# 4. GET /audiences/1, handle url params
request = """
GET /audiences/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

audiences 1
"""

# 5. rewrite GET /elixians to GET /audiences


# 6. GET /about, read content from a file
request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# 7. new modules: Plugins, Parser, Conn

# 8. post a request, parsing headers, parsing params

request = """
POST /speakers HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=newguys&corp=localgravity
"""

response = """
HTTP/1.1 201 Created
Content-Type: text/html
Content-Length: 20

a new speaker created
"""

# 9. create speaker_controller with index, show, create actions

# 10. Speaker struct
defmodule Meetup.Speaker do
  defstruct id: nil, name: "", corp: "", elixir_adapted: false 
end

defmodule Meetup.ElixirShenzhen do
  alias Meetup.Speaker

  def list_speakers do
    [
      %Speaker{id: 1, name: "YinWeijun", corp: "Localgravity", elixir_adapted: true},
      %Speaker{id: 2, name: "MuLixiang", corp: "Localgravity"},
      %Speaker{id: 3, name: "Chase", corp: "Facebook"},
      %Speaker{id: 4, name: "Thomas", corp: "Amazon"}
    ]
  end
end

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



