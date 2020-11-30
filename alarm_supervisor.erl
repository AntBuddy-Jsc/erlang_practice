-module(alarm_supervisor).
-behaviour(supervisor).

-export([start_link/1]).
-export([init/1, stop/1]).

start_link(Work) ->
    supervisor:start_link({local,?MODULE}, ?MODULE, Work).

init(onefall) ->
    init({one_for_all, 1, 60});
init(alarm) -> %     {ok, {SupFlags, ChildSpecs}}.
    {ok, 
	{  {one_for_all, 1, 60}, % SupFlags
           [			 % ChildSpecs
	     {	alarm_sup,   				% child_id, (mandatory)
		{alarm_genserver, start_link, [alarm]},	% start = a tuple of {module, function, agruments}, this is mandatory
		permanent,				% restart() = permanent | transient | temporary. This is optional
		1000,					% shutdown() = brutal_kill | timeout(). This is optional
		worker,					% worker() = worker | supervisor. This is optional
		[alarm_genserver]			% modules() = [module()] | dynamic. This is optional
	     }
          ]
	}
   };
init(turning) -> %     {ok, {SupFlags, ChildSpecs}}.
    {ok, 
	{  {one_for_one, 2, 60}, % SupFlags
           [			 % ChildSpecs
	     {	turning_sup,   				% child_id, (mandatory)
		{alarm_genserver, start_link, [turning]},	% start = a tuple of {module, function, agruments}, this is mandatory
		permanent,				% restart() = permanent | transient | temporary. This is optional
		1000,					% shutdown() = brutal_kill | timeout(). This is optional
		worker,					% worker() = worker | supervisor. This is optional
		[alarm_genserver]			% modules() = [module()] | dynamic. This is optional
	     }
          ]
	}
   }.
%init({RestartStrategy, MaxRestart, MaxTime}) ->
 %   {ok, {{RestartStrategy, MaxRestart, MaxTime},
  %       [{alarm,
   %        {alarm_genserver, start_link, [alarm]},
    %       permanent, 1000, worker, [alarm_genserver]},
     %     {turning,
      %    {alarm_genserver, start_link, [turning]},
       %    permanent, 1000, worker, [alarm_genserver]}
        % ]}}.

stop(alarm) ->
	supervisor:terminate_child(?MODULE, alarm_sup).
stop(turning) ->
	supervisor:terminate_child(?MODULE, turning_sup).
