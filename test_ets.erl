-module(test_ets).
-compile(export_all).
-record(person, {name, age, phone, email}).

create(_name) ->
%	io:format("before create~n"),
	ets:new(_name, [set, named_table, {keypos,1}]).
%	ets:new(_name, [set, named_table]).
	%io:format("after create~n").

insert(_name, P=#person{}) ->
%	io:format("Ten per = ~p~n",[P#person.name]),
	ets:insert_new(_name, {P#person.name, P#person.age, P#person.phone, P#person.email}).
%	io:format("After insert~n").

search(_name, P=#person{}) ->
	io:format("Search person~n"),
	ets:lookup(_name, P#person.name);
search(_name, _arg) ->
	io:format("Search _arg~n"),
	ets:lookup(_name, _arg).
person(_name, _age, _phone, _email) -> %return a record
	if 
	   is_number(_age) ->
		io:format("Name: ~p~n",[_name]),
		io:format("Age: ~p~n",[_age]),
		io:format("Phone: ~p~n",[_phone]),
		io:format("Email: ~p~n",[_email]),
		Per = #person{name=_name, age=_age, phone=_phone, email=_email},
		Per;
	   true ->
		io:format("Wrong data type!")
	end.

is_person(_a) -> is_record(_a, person). %check if a is a person record




%c(test_ets).
%rr(test_ets).
%P1=test_ets:person(ten, 23, 89393, mail1).
%P2=test_ets:person(ten, 18, 423, mail2).
%test_ets:create(tab).
%test_ets:insert(tab,P1).
%test_ets:search(tab,P1).  => [{ten,23,89393,mail}]
%test_ets:insert(tab,P2).
%test_ets:search(tab,P2).  => [{ten,18,423,mail}]
%test_ets:search(tab,P1).  => [{ten,18,423,mail}]
