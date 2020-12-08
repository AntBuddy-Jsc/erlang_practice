-module(test_ets).
-compile(export_all).
-record(person, {name, age, phone, email}).

create(Name) -> 									%create table Name
	ets:new(Name, [bag, named_table, {keypos,1}]). 	%default keypos=1

insert(Name, P=#person{}) -> 						%insert new object for table Name
	ets:insert(Name, {P#person.name, P#person.age, P#person.phone, P#person.email}).  

search(Name, P=#person{}) -> 						%search name person P in Name, mean key 
	io:format("Search person ~p~n",[P#person.name]),
	ets:lookup(Name, P#person.name);

search(Name, Arg) -> 								%search key=_arg
	io:format("Search _arg~n"),
	ets:lookup(Name, Arg).

person(Name, Age, Phone, Email) -> 					%return a record
	if 
		is_number(Age) ->
			Person = #person{name=Name, age=Age, phone=Phone, email=Email},
			Person;
		true ->
			io:format("Wrong data type!")
	end.

is_person(Arg) -> is_record(Arg, person). 			%check if Arg a is a person record

print(Table) -> 									%print list data in table
	io:format("Table is: ~p~n",[ets:tab2list(Table)]).

%=================================================================================
%data to test
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
