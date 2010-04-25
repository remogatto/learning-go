-module(spawn).
-export([start/1]).

start([A]) ->
    N = list_to_integer(atom_to_list(A)),
    statistics(wall_clock),	
    L = for(1, N, fun() -> spawn(fun() -> wait() end) end),
    {_, WallClock} = statistics(wall_clock),
    lists:foreach(fun(Pid) -> Pid ! die end, L),
    io:format("~p", [WallClock * 1000 / N]).
wait() ->
    receive
        die -> void
    end.

for(N, N, F) -> [F()];
for(I, N, F) -> [F()|for(I + 1, N, F)].
