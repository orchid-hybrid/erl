-module(thx).
-compile(export_all).

plugin(PID) ->
 receive
   {_,{ok,{_,"MODE",[Chan,Mode,"erl"],[]}}} ->
    PID ! {raw,"PRIVMSG " ++ Chan ++ " :thx for the " ++ Mode ++ "!!"},
    thx:plugin(PID);
    _ -> thx:plugin(PID)
 end.
