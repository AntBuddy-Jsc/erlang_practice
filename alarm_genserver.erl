-module(alarm_genserver).
-behaviour(gen_server).

-export([start_link/1, stop/1, send_after/1]).
-export([init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	code_change/3,
	terminate/2]).
-define(TIME, 10000).
%===================== API function =====================
send_after(_State) ->
	io:format("before send~n"),
	erlang:send_after(?TIME, _State, start_link(_State)).
	%io:format("after send~n").
start_link(State) -> %spawn and link gen_server State
	gen_server:start_link({local,State}, ?MODULE, State, []).
	%erlang:send_after(20000, self(), State).

stop(State) -> % stop gen_server process
	gen_server:call(State, stop).

%================== Call back function ==================
init(State) -> % initialize new process
	%io:format("State Pid = ~p, self = ~p ~n",[whereis(State),self()]),
	io:format("Init here on genserver!! State = ~p~n",[State]),
	{ok,State,200}.

handle_call(stop, _From, State) -> %handle stop(State)
	io:format("This is handle call stop from State ~p, _From = ~p~n",[State,_From]),
	{stop, normal, ok, State};
handle_call(_Message, _From, State) -> %handle init
	io:format("This is handle call Message = ~p, _From = ~p, State = ~p)~n",	
		[_Message, _From, State]),
    	{noreply, State, 500}.

handle_cast(_Message, State) -> %handle function genserver:cast
	io:format("This is handle cast~n"),
    	{noreply, State, 700}.

handle_info(timeout, alarm) -> % handle with State = alarm, next state is turning
	io:format("    Ringging !!!~n"),
	{noreply,turning,2000};
handle_info(timeout, turning) -> % handle with State = turning, next state is alarm
	io:format(" Shaking   !!!~n"),
	{noreply,alarm,1000};

handle_info(_Message, State)-> % handle function init, next State is alarm
	io:format("This is handle_info Message = ~p, State = ~p)~n",[_Message,State]),
	{noreply, alarm, 3500}.

code_change(_OldVsn, State, _Extra) -> %update internal state
    	{ok, State}.

terminate(_Reason, _State) -> % stop genserver
	io:format("This is terminal on genserver~n"),
    	ok.
%send_after(Time, ?MODULE, Msg)
