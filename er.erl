-module(er).
-compile(export_all).

-import(irc_parser, [parse/1]).
-import(ping, [plugin/1]).

% ":irc.example.net 433 * er :Nickname already in use"

% {ok,P,Q} = er:go().
% P ! {add, spawn(ping, plugin, [Q])}.
% P ! {add, spawn(ping_counter, plugin, [Q,0])}.

go() ->
 Relay = spawn(relay, relay, [[]]),
 Self = spawn(fun() -> start(Relay) end),
 {ok, Relay, Self}.

boot_plugins(P,Q) ->
  P ! wipe,
  P ! {add, spawn(ping, plugin, [Q])},
  P ! {add, spawn(ping_counter, plugin, [Q,0])},
  P ! {add, spawn(bot, plugin, [Q])},
  P ! {add, spawn(invite, plugin, [Q])}.

start(Relay) ->
    {ok, Socket} = gen_tcp:connect("irc.freenode.net", 6667, [list, {packet, line}, {active, true}, {reuseaddr, true}]),
    ok = gen_tcp:send(Socket, "USER er er er er\r\n"),
    ok = gen_tcp:send(Socket, "NICK erl\r\n"),
    ok = gen_tcp:send(Socket, "JOIN #erl\r\n"),
    loop(Socket, Relay).

loop(Socket, Relay) ->
    receive
        {tcp, _, Data} ->
	    er:body(string:tokens(Data, "\r\n"), Socket, Relay);
	{raw, Msg} ->
	    ok = gen_tcp:send(Socket, Msg ++ "\r\n"),
	    er:loop(Socket, Relay)
    end.

body([], Socket, Relay) ->
 er:loop(Socket, Relay);
body([Data|Rest], Socket, Relay) ->
 Parsed = parse(Data),
 io:format("Socket ~p~n", [Parsed]),
 Relay ! {broadcast, {Data, Parsed}},
 er:body(Rest, Socket, Relay).
