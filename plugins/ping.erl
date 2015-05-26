-module(ping).
-compile(export_all).

plugin(PID) ->
 receive
   {Data,_} ->
    ping:handle(Data, PID),
    ping:plugin(PID)
 end.

handle("PING" ++ Rest, PID) ->
  PID ! {raw,"PONG" ++ Rest},
  ok;
handle(_, _) -> ok.
