-- Lua call/cc sample
-- This script working with coroutine.clone path
-- http://lua-users.org/lists/lua-l/2006-01/msg00652.html

local pc
local continuation
local params

function f1 ()
   print "f1"

   r = callcc (
      function (ret)
	 local x = "hogehoe"
	 print "f2"
	 ret (x)
	 print "f2: after cont"
      end
   )

   print ("f1: got " .. r)
   pc = nil
end

-- (let* ((yin ((lambda (foo) (newline) foo)
--              (call/cc (lambda (bar) bar))))
--        (yang ((lambda (foo) (write-char #\*) foo)
--               (call/cc (lambda (bar) bar)))))
--   (yin yang))

function callccpuzzle ()
   local yin = ((function (foo)
		    io.stdout:write ("\n")
		    return foo
		 end) (
		   callcc (
		      function (bar)
			 bar (bar)
		      end)))
   local yang = ((function (foo)
		     io.stdout:write ("*")
		     return foo
		  end) (
		    callcc (
		       function (bar)
			  bar (bar)
		       end)))
   yin (yang)
end

function callcc (func)
   continuation = pc
   pc = coroutine.create (func)
   params = nil

   local r
   cont, r = coroutine.yield ()

   return r
end

function make_cont_func (cont)
   local current_continuation = cont
   return function (x)
	     pc = coroutine.clone (current_continuation)
	     continuation = nil
	     params = x
	     coroutine.yield ()
	  end
end

function base (f)
   pc = coroutine.create (f)
   continuation = nil
   params = nil
   while (pc) do
      coroutine.resume (pc, make_cont_func (continuation), params)
   end
end

base (callccpuzzle)
-- base (f1)
