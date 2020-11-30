-module(alarm_genserver).
-behaviour(gen_server).

-export([start_link/1, stop/1]).
-export([init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	code_change/3,
	terminate/2]).

start_link(State) ->
	gen_server:start_link({local,State}, ?MODULE, [], []).

stop(State) ->
	gen_server:call(State, stop).

init(State) ->
	process_flag(trap_exit, true),
	io:format("Init here!! State = ~p~n",[State]),
	{ok,State,2500}.

handle_call(stop, _From, State) ->
	io:format("This is handle call stop from State ~p, _From = ~p~n",[State,_From]),
	{stop, normal, ok, State};
handle_call(_Message, _From, State) ->
	io:format("This is handle call Message = ~p, _From = ~p, State = ~p)~n",	
		[_Message, _From, State]),
    	{noreply, State, 500}.

handle_cast(_Message, State) ->
	io:format("This is handle cast~n"),
    	{noreply, State, 700}.

handle_info(timeout, alarm) ->
	io:format("Ringging!!!~n"),
	{noreply,turning,2000};
handle_info(timeout, turning) ->
	io:format("Shaking   !!!~n"),
	{noreply,alarm,1000};
handle_info(_Message, State)->
	io:format("This is handle_info Message = ~p, State = ~p)~n",[_Message,State]),
	{noreply, alarm, 3500}.

code_change(_OldVsn, State, _Extra) ->
    	{ok, State}.

terminate(_Reason, _State) ->
	io:format("This is terminal~n"),
    	ok.
%send_after(Time, ?MODULE, Msg)
