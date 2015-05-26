-module(bot).
-compile(export_all).

plugin(PID) ->
 receive
   {_,{ok,{_,"PRIVMSG",[Chan],"!bot"}}} ->
    PID ! {raw,"PRIVMSG " ++ Chan ++ " :not just now"},
    bot:plugin(PID);
   _ -> bot:plugin(PID)
 end.
