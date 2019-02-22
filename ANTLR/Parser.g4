grammar Parser;

//parser rules

integer : INTEGER ;
var : VAR ;

value : integer | var ;

block : BEGIN END #emptyblock
	  | BEGIN stmt END #block1
	  | BEGIN sequence END #block1; 

//TODO: poti sa adaugi paranteze ca sa fie mai corect la bxpr

daca : IF bxpr block ELSE block ; 

axpr :  axpr DIV axpr #div
	 |  axpr PLUS axpr #plus
	 |	OPEN axpr CLOSE #paranthesisA
	 |  value #valueNode ;

bool : TRUE | FALSE; 

//paranthesisB : OPEN bxpr CLOSE ;
//parantheesisA : OPEM axpr

bxpr : bool #boolNode
	 | axpr GREATER axpr #greater
	 | NOT bxpr #not
	 | bxpr AND bxpr #and
	 | OPEN bxpr CLOSE #paranthesisB ; 

stmt : assign
	 | cand 
	 | daca ;

sequence : stmt sequence
		 | stmt stmt;

varlist : varlist COMMA VAR
		| VAR ;

prog :  INT varlist SEMICOLUMN sequence 
	 |  INT varlist SEMICOLUMN stmt ;
	 

assign : var EGAL axpr SEMICOLUMN; 

cand : WHILE bxpr block ;	

//Lexer rules

WS : [ \t\r\n]+ -> skip ;

GREATER : '>' ;
NOT : '!' ;
AND : '&&' ;
EGAL : '=' ;
DIV : '/' ;
PLUS : '+' ;
END : '}' ;
BEGIN : '{' ;
CLOSE : ')' ;
OPEN : '(' ;
INTEGER : [1-9]+ | ([1-9] [0-9]*) | '0' ;
INT : 'int' ;
COMMA : ',' ;
SEMICOLUMN : ';' ;
IF : 'if' ;
ELSE : 'else' ;
WHILE : 'while' ;
TRUE : 'true' ;
FALSE : 'false' ;
VAR : [a-z]+;