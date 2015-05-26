-module(relay).
-compile(export_all).

relay(L) ->
 receive
  wipe ->
   relay:relay([]);
  {add,PID} ->
   relay:relay([PID|L]);
  {remove,PID} ->
   relay:relay(lists:delete(PID,L));
  {broadcast,Msg} ->
   ok = lists:foreach(fun(PID) -> PID ! Msg end, L),
   relay:relay(L)
 end.
