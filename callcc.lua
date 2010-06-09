local pc
local continuation
local params

function callcc (func)
   continuation = pc
   pc = coroutine.create (func)
   params = nil

   local r
   cont, r = coroutine.yield ()

   return r
end

local function make_cont_func (cont)
   local current_continuation = cont
   return function (x)
             pc = coroutine.clone (current_continuation)
             continuation = nil
             params = x
             coroutine.yield ()
          end
end

function callcc_run (f)
   pc = coroutine.create (f)
   continuation = nil
   params = nil
   while (pc) do
      coroutine.resume (pc, make_cont_func (continuation), params)
   end
end
