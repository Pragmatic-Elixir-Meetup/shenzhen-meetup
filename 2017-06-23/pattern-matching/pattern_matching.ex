
# (MatchError) no match of right hand side value
# 左边尽可能地跟右边匹配上
#
# destruct complex data
# 

a = 1

1 = a

# only rebinding value on the left hand side of `=` sign
2 = a

# the pin operator ^ is used to access the previously bound values

b = 3

^b = 4

# what if you do
1 = c


#
# pattern matching on list, tuple
#

list = [1, 2, 3, 4]

[a, b, c, d] = list; b

[head | tail] = list; tail

[a, a | tail] = list; tail

[a, a, b | tail] = list; tail

#
# pattern matching on map
#

# ** (CompileError) iex:14: illegal use of variable key inside map key match, 
# maps can only match on existing variable by using ^key
%{key => value} = %{"foo" => "bar"}

%{key => "bar"} = %{"foo" => "bar"}

key = "foo"

%{^key => value} = %{"foo" => "bar"}; value

presenter = %{name: "yin weijun", role: "developer", languages: [:elixir, :ruby, :javascript, :scala]}

# you can pattern matching selected keys
%{name: name} = presenter

%{name: name, unknown: unknown} = presenter


#
# the pin operator with function
#

greeting = "Hello"

greet = fn
  (^greeting, name) -> "Hi #{name}"
  (greeting, name) -> "#{greeting}, #{name}"
end

greet.("Hello", "Sean")

greet.("Morning", "Sean")


#
#. special things
#

# ignore value with underscore _
_

length([1, [2], 3]) = 3


# another ways to look at the sign =
# 1. variables bind once per match in elixir, while variables bind once in erlang
# 2. 代数中的断言. e.g. x = y + 1

# References:
# https://elixir-lang.org/getting-started/pattern-matching.html
# chapter 2, programming elixir 1.3
# https://elixirschool.com/lessons/basics/pattern-matching/

