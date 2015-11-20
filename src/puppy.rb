require 'byebug'
require 'algorithms'

@stack = Containers::Stack.new
@program = nil

@commands = {}

def do_all *commands
  if commands.first.kind_of?(Containers::Queue) or commands.first.kind_of?(Array)
    execute_commands commands.first
  else
    execute_commands(Containers::Queue.new commands)
  end
end

def execute_commands queue
  queue.each do |command|
    execute(command)
  end
end

def execute command
  if @commands.include?(command)
    @commands[command].call
  else
    @stack.push command
  end
end

def define command, &b
  @commands[command] = b
end

def program *commands
  @program = Containers::Queue.new commands

  do_all @program
end

define :print do
  bottom = @stack.pop
  puts bottom
  @stack.push print
end

define :+ do
  right = @stack.pop
  left = @stack.pop
  @stack.push left + right
end

define :- do
  right = @stack.pop
  left = @stack.pop
  @stack.push left - right
end

define :* do
  right = @stack.pop
  left = @stack.pop
  @stack.push left * right
end

define :^ do
  right = @stack.pop
  left = @stack.pop
  @stack.push left / right
end

define :^ do
  right = @stack.pop
  left = @stack.pop
  @stack.push left % right
end

define :< do
  right = @stack.pop
  left = @stack.pop
  @stack.push left < right
end

define :> do
  right = @stack.pop
  left = @stack.pop
  @stack.push left > right
end

define :== do
  right = @stack.pop
  left = @stack.pop
  @stack.push left == right
end

define :not do
  value = @stack.pop
  @stack.push !value
end

define :and do
  right = @stack.pop
  left = @stack.pop
  @stack.push left && right
end

define :or do
  right = @stack.pop
  left = @stack.pop
  @stack.push left || right
end

define :xor do
  right = @stack.pop
  left = @stack.pop
  @stack.push left ^ right
end

define :drop do
  @stack.pop
end

define :dup do
  value = @stack.pop
  2.times do
    @stack.push value
  end
end

define :swap do
  right = @stack.pop
  left = @stack.pop
  @stack.push right
  @stack.push left
end

define :define do
  name = @stack.pop
  commands = @stack.pop
  @commands[name] = lambda do
    commands.each do |command|
      execute command
    end
  end
end

define :rotate do
  z = @stack.pop
  y = @stack.pop
  x = @stack.pop

  @stack.push y
  @stack.push z
  @stack.push x
end

define :rrotate do
  z = @stack.pop
  y = @stack.pop
  x = @stack.pop

  @stack.push z
  @stack.push x
  @stack.push y
end

define :over do
  y = @stack.pop
  x = @stack.pop

  @stack.push x
  @stack.push y
  @stack.push x
end

define :depth do
  @stack.push @stack.size
end

define :call do
  commands = @stack.pop
  do_all commands
end

program 3, 4, :+, :print
