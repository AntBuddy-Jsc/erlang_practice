-module(test_ets).
-compile(export_all).
-record(person, {name, age, phone, email}).

create(_name, P=#person{}) -> %create and set first value for table _name
%	io:format("before create~n"),
%	ets:new(_name, [set, named_table, {keypos,1}]),
	ets:new(_name, [bag, named_table, {keypos,1}]), %default keypos=1
	ets:insert(_name, {P#person.name, P#person.age, P#person.phone, P#person.email}).

	%io:format("after create~n").

insert(_name, P=#person{}) -> %insert new object for table _name
%	io:format("Ten per = ~p~n",[P#person.name]),
%	ets:insert_new(_name, {P#person.name, P#person.age, P#person.phone, P#person.email}).
	ets:insert(_name, {P#person.name, P#person.age, P#person.phone, P#person.email}). %use for insert object into [bag] table
%	io:format("After insert~n").

search(_name, P=#person{}) -> %search name person P in _name, mean key 
	io:format("Search person ~p~n",[P#person.name]),
	ets:lookup(_name, P#person.name);
search(_name, _arg) -> %search key=_arg
	io:format("Search _arg~n"),
	ets:lookup(_name, _arg).
person(_name, _age, _phone, _email) -> %return a record
	if 
	   is_number(_age) ->
		Person = #person{name=_name, age=_age, phone=_phone, email=_email},
		Person;
	   true ->
		io:format("Wrong data type!")
	end.

is_person(_a) -> is_record(_a, person). %check if a is a person record


%c(test_ets).
%rr(test_ets).
%P1=test_ets:person(ten, 23, 89393, mail1).
%P2=P1.
%P3=test_ets:person(ten, 12, 4333, mail3).
%P4=test_ets:person(ten4, 16, 123, mail4).
%test_ets:create(tab,P1).	=> true
%test_ets:search(tab,P1).	=> [{ten,23,89393,mail1}]
%test_ets:insert(tab,P2).	=> true ???? P2=P1, why?
%test_ets:insert(tab,P3).	=> true
%test_ets:insert(tab,P4).	=> true
%test_ets:search(tab,P1).	=> [P1 or P2, P3]   [{ten,23,89393,mail1},{ten,12,4333,mail3}]
%test_ets:search(tab,P2).	=> same above
%test_ets:search(tab,P3).	=> same above
%test_ets:search(tab,P4).	=> [{ten4,16,123,mail4}]
