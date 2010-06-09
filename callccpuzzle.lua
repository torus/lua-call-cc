require "callcc"

-- (let* ((yin ((lambda (foo) (newline) foo)
--              (call/cc (lambda (bar) bar))))
--        (yang ((lambda (foo) (write-char #\*) foo)
--               (call/cc (lambda (bar) bar)))))
--   (yin yang))

function write (text)
   io.stdout:write (text)
end

function callccpuzzle ()
   local yin = ((function (foo) write ("\n"); return foo end) (
                  callcc (function (bar) bar (bar) end)))
   local yang = ((function (foo) write ("*"); return foo end) (
                   callcc (function (bar) bar (bar) end)))
   yin (yang)
end

callcc_run (callccpuzzle)
