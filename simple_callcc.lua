require "callcc"

function get_input (cont)
  io.stdout:write "number? "
  local x = io.stdin:read ()
  local num = tonumber (x)

  if num then
    cont (num)                  -- escape
  end

  print "failed"
end

function main ()
  local input = callcc (function (cont)
                          while true do
                            get_input (cont)
                            print "retry"
                          end
                        end)

  print ("got number: ", input)
end

callcc_run (main)
