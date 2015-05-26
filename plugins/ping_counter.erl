-module(ping_counter).
-compile(export_all).

plugin(PID, Counter) ->
 receive
   {Data,_} ->
    {ok, NCounter} = ping_counter:handle(Data, PID, Counter),
    ping_counter:plugin(PID, NCounter)
 end.

handle("PING" ++ Rest, PID, Counter) ->
  PID ! {raw,"PRIVMSG #erl :" ++ integer_to_list(Counter) ++ " pings!"},
  {ok, Counter + 1};
handle(_, _, Counter) -> {ok, Counter}.
