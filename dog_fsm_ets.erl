-module(dog_fsm_ets).

-behaviour(gen_fsm).
%-compile(export_all).
%% API
-export([start_link/1, stop/0]).
-export([squirrel/0, pet/0, smell/0, delete/1]).

%% gen_fsm callbacks
-export([init/1, add/3, print/1,
         barking/2,
         wagging_tail/2,
         sitting/2,
	 	 smelling/2,
         handle_event/3,
         handle_sync_event/4,
         handle_info/3,
         terminate/3,
         code_change/4]).

-define(SERVER, ?MODULE).
-define(BARKING_TIME, 5000).
-define(WAGGING_TIME, 13000).
-define(FINDING_TIME, 7500).
-define(SITTING_TIME, 30000).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Table) -> %spawn and link, create table
	io:format("before create new table~n"),
 	gen_fsm:start_link({local, ?SERVER}, ?MODULE, [Table], []).

stop() ->
  	gen_fsm:send_all_state_event(?SERVER, stop).

squirrel() ->
  	gen_fsm:send_event(?SERVER, squirrel).

pet() ->
	gen_fsm:send_event(?SERVER, pet).

smell() ->
	gen_fsm:send_event(?SERVER, smell).

print(Table) ->
	io:format("Table is: ~p~n",[ets:tab2list(Table)]).

delete(Table) -> %delete table
	io:format("You're about to delete table ~p~n",[Table]),
	ets:delete(Table).
%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================

init([Table]) ->
	ets:new(Table, [duplicate_bag, named_table]),
%	ets:insert(Table,{0,0,0}),
  	{ok, barking, Table, 1000}.

barking(Event, Table) -> %handle state barking
	print(Table),
	case Event of
		pet ->
			wag(),
			io:fwrite("Next state: wagging_tail~n...Ready...~n~n"),
			{next_state, wagging_tail, add(Table,'wag',Event), ?WAGGING_TIME};
		timeout ->
			bark(),
			io:fwrite("Next state: barking~n...Ready...~n~n"),
			{next_state, barking, add(Table,'bark',Event), ?BARKING_TIME};
		smell ->
			find(),
			io:fwrite("Next state: smelling~n...Ready...~n~n"),
			{next_state, smelling, add(Table,'find',Event), ?FINDING_TIME};
    	_ ->
			io:format("Dog is confused~n...Ready...~n"),
			io:fwrite("Next state: barking~n...Ready...~n~n"),
         	{next_state, barking, add(Table,'confused',Event), 0}
        end.

wagging_tail(Event, Table) -> %handle state wagging_tail
	print(Table),
	case Event of
       	pet ->
         	sit(),
 			io:fwrite("Next state: sitting~n...Ready...~n~n"),
   			{next_state, sitting, add(Table,'sit',Event), ?SITTING_TIME};
		timeout ->
			io:fwrite("Next state: barking~n...Ready...~n~n"),
         	{next_state, barking, add(Table,'timeout',Event), 0};
		squirrel ->
			io:fwrite("Next state: barking~n...Ready...~n~n"),
      		{next_state, barking, add(Table,'squirrel',Event), 0};
		smell ->
			find(),
			io:fwrite("Next state: smelling~n...Ready...~n~n"),
			{next_state, smelling, add(Table,'find',Event), ?FINDING_TIME};
     	_ ->
           	io:format("Dog is confused~n...Ready...~n"),
           	wag(),	
			io:fwrite("Next state: wagging_tail~n...Ready...~n~n"),
   			{next_state, wagging_tail, add(Table,'confused',Event), ?WAGGING_TIME}
     end.

sitting(Event,Table) -> %handle state sitting
	print(Table),
  	case Event of
		squirrel ->
			io:fwrite("Next state: barking~n...Ready...~n~n"),
      		{next_state, barking, add(Table,'squirrel',Event), 0};
		smell ->
			find(),
			io:fwrite("Next state: smelling~n...Ready...~n~n"),
			{next_state, smelling, add(Table,'find',Event), ?FINDING_TIME};
  		_ ->
			io:format("Dog is confused~n...Ready...~n"),
			sit(),
			io:fwrite("Next state: sitting~n...Ready...~n~n"),
  			{next_state, sitting, add(Table,'confused',Event)}
	end.

smelling(Event, Table) -> %handle state amelling
	print(Table),
	case Event of
		pet ->
			wag(),
 			io:fwrite("Next state: smelling~n...Ready...~n~n"),
     		{next_state, smelling, add(Table,'wag',Event), ?FINDING_TIME};
		squirrel ->
			io:fwrite("Next state: barking~n...Ready...~n~n"),
			{next_state, barking, add(Table,'squirrel',Event), 0};
		_ ->
			find(),
			io:fwrite("Next state: smelling~n...Ready...~n~n"),
			{next_state, smelling, add(Table,'find',Event), ?FINDING_TIME}
	end.
		
handle_event(stop, _StateName, Table) -> %handle func dog_fsm_ets:stop()
	io:fwrite("Dog is running away!~n"),
	{stop, normal, Table};
handle_event(_Event, StateName, Table) -> %gen_fsm call back func
   	{next_state, StateName, Table}.

handle_sync_event(_Event, _From, StateName, StateData) -> %gen_fsm call back func
    Reply = ok,
    {reply, Reply, StateName, StateData}.

handle_info(_Info, StateName, StateData) -> %gen_fsm call back func
    {next_state, StateName, StateData}.

terminate(_Reason, _StateName, _StateData) -> %gen_fsm call back func
    ok.

code_change(_OldVsn, StateName, StateData, _Extra) -> %gen_fsm call back func
    {ok, StateName, StateData}.

  %%%===================================================================
  %%% Internal functions
  %%%===================================================================
bark() ->
	io:format("Dog says: BARK! BARK!~n").

wag() ->
	io:format("Dog wags its tail~n").

sit() ->
	io:format("Dog is sitting. Gooooood boy!~n").

find() -> 
	io:format("Dog is finding for food~n").

add(Table, Arg1, Arg2) ->
	ets:insert(Table,{Arg1, Arg2}),
	Table.


