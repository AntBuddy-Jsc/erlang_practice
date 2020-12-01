-module(test_timer).
%====================================================
%%Call by test_timer:start_link(<Message>,<Period time>).
% Message: atom
% Period time: integer and greater than 0, mili second
% can start many difference 
% After a <Period time>, show a message to remind do work <Message>
%====================================================
-behaviour(gen_server).

%% gen_listener functions
-export([start_link/2
	,stop/1
        ,init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
        ]).

%-define(DO_SOMETHING_PERIOD, 3000).
%-define(DO_SOMETHING_MSG, 'time_to_do_something').

-record(state, {msg, period_time,
          timer_ref :: reference()
         }).

stop(Msg) -> 
    gen_server:cast(Msg, 'stop'). %call handle cast to handle stop process

start_link(Msg, Time) -> % spawm and link process Msg
    gen_server:start_link({local, Msg}, ?MODULE, [Msg, Time], []). %Msg in {local, Msg} is name of process

init([Msg, Time]) -> % call back function init. func start_timer(Msg, Time) return a time reference
    io:format("Started timer of ~p~n",[Msg]),
    {'ok', #state{ msg=Msg, period_time=Time, timer_ref=start_timer(Msg, Time) } }.

start_timer(Msg, Time) -> % start timer, after Time(mili second), send message Msg to it self process, that is handle by handle_info func. Return a time reference
%    io:format("start timer~n"),
    erlang:send_after(Time, self(), Msg). %Msg can be replaced by any term, that is send to handle_info

handle_info(Msg, State = #state{period_time = Time}) -> %handle when process receive message Msg
    io:format("It's time to: ~p~n", [Msg]),
    {'noreply', State#state{msg = Msg, timer_ref=start_timer(Msg, Time)}}.

handle_cast('stop', #state{msg = Msg, timer_ref=TimerRef} = State) when is_reference(TimerRef) -> %handle stop(Msg)
    io:format("This is handle cast ~p with stop~n",[Msg]),
    {'stop', 'normal', State};

handle_cast(_Req, State) -> %handle func genserver:cast with not stop request
    io:format("unhandled cast: ~p~n", [_Req]),
    {'noreply', State}.

handle_call(_Req, _From, State) -> %handle func genserver:call
    io:format("This is handle call~n"),
    {'reply', 'ok', State}.

code_change(_OldVsn, State, _Extra) -> %update internal state
    io:format("Update~n"),
    {'ok', State}.

terminate(_Reason, #state{timer_ref=TimerRef})  when  is_reference(TimerRef) -> %cancel timer 
    erlang:cancel_timer(TimerRef),
    io:format("test_timer cancel: ~p~n", [_Reason]);
terminate(_Reason, _) ->
    io:format("test_timer terminating: ~p~n", [_Reason]).

