-module(invite).
-compile(export_all).

plugin(PID) ->
 receive
   {_,{ok,{_,"INVITE",[_],Chan}}} ->
    PID ! {raw,"JOIN " ++ Chan},
    invite:plugin(PID);
    _ -> invite:plugin(PID)
 end.
