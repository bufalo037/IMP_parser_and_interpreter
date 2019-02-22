//package JFlex;

import java.util.*;
//import java.util.HashMap;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;


%%
 
%class Parser
%standalone
%line

%{
  	private HashMap<String, Integer> vars = new HashMap<String, Integer>();

  	private Stack<String> operators = new Stack<String>();
  	private LinkedList<ValueNode> values = new LinkedList<ValueNode>();
  	private LinkedList<LinkedList<Node>> sequences = new LinkedList<LinkedList<Node>>();
  	private HashMap<String, Integer> priority = new HashMap<String, Integer>();
  	private ValueNode variable_to_assign;
  	private LinkedList<String> conditions = new LinkedList<String>();
  	private int line = 1;
  	private MainNode main_node;

  	void init()
  	{
  		priority.put("&&",1);
  		priority.put("!", 2);
  		priority.put(">", 3);
  		priority.put("+", 4);
  		priority.put("/", 5);
  		sequences.addLast(new LinkedList<Node>());
  	}

  	void make_value_node(String op)
  	{
  		switch(op)
		{
			case "+":
			{
				ValueNode n2 = values.removeLast();
				ValueNode n1 = values.removeLast();
				values.addLast(new PlusNode(n1, n2));
				break;
			}
			case "/":
			{
				ValueNode n2 = values.removeLast();
				ValueNode n1 = values.removeLast();
				values.addLast(new DivNode(n1, n2, yyline + 1));
				break;
			}
			case "&&":
			{
				ValueNode n2 = values.removeLast();
				ValueNode n1 = values.removeLast();
				values.addLast(new AndNode(n1, n2));
				break;
			}
			case "!":
			{
				ValueNode n1 = values.removeLast();
				values.addLast(new NotNode(n1));
				break;
			}
			case ">":
			{
				ValueNode n2 = values.removeLast();
				ValueNode n1 = values.removeLast();
				values.addLast(new GreaterNode(n1, n2));
				break;
			}
		}
  	}

  	class UnassignedVarException extends RuntimeException
  	{
  		UnassignedVarException(int line)
  		{
  			super("UnassignedVar " + line);
  		}
  	}

  	class DivideByZeroException extends RuntimeException
  	{
  		DivideByZeroException(int line)
  		{
  			super("DivideByZero " + line);
  		}
  	}


  	interface IsValueNode
  	{
  		String get_value();
  	}


  	abstract class Node
  	{
  		int nivelIden;
  		Node()
  		{

  		}
  		void set_nivelIden(int nivelIden)
  		{
  			this.nivelIden = nivelIden;
  		}

  		void get_UnassignedVarException() throws UnassignedVarException
  		{

  		}

  		String get_name()
  		{
  			return null;
  		}

  		abstract void eval();
  	}


  	abstract class ValueNode extends Node implements IsValueNode
  	{

  	}


  	class MainNode extends Node
  	{
  		private Node node;

  		MainNode(Node node)
  		{
  			super();
  			this.node = node;
  			this.set_nivelIden(0);
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			try{
  				node.eval();
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			node.get_UnassignedVarException();
  		}

  		@Override
  		public String toString()
  		{
  			node.set_nivelIden(1);
  			return "<MainNode>" + "\n" + node.toString();
  		}
  	}

  	class AssignmentNode extends Node
  	{
  		private ValueNode var;
  		private ValueNode expr;
  		private int line;

  		AssignmentNode(ValueNode var, ValueNode expr, int line)
  		{
  			super();
  			this.var = var;
  			this.expr = expr;
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			var.get_UnassignedVarException();
  			expr.get_UnassignedVarException();
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			try{
  				if(vars.containsKey(var.get_name()))
  				{
  					vars.put(var.get_name(), Integer.valueOf(expr.get_value()));
  				}
  				else
  				{
  					throw new UnassignedVarException(line);
  				}
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			var.set_nivelIden(nivelIden + 1);
  			expr.set_nivelIden(nivelIden + 1);
  			for(int i = 0; i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<AssignmentNode> =" + "\n" + var.toString() + expr.toString();
  		}
  	} 


  	class IfNode extends Node
  	{

  		private ValueNode test;
  		private Node then;
  		private Node altfel;

  		IfNode(ValueNode test, Node then, Node altfel)
  		{
  			super();
  			this.test = test;
  			this.then = then;
  			this.altfel = altfel;
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			test.get_UnassignedVarException();
  			then.get_UnassignedVarException();
  			altfel.get_UnassignedVarException();
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			try{
  				if(Boolean.valueOf(test.get_value()))
  				{
  					then.eval();
  				}
  				else
  				{
  					altfel.eval();
  				}
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			test.set_nivelIden(nivelIden + 1);
  			then.set_nivelIden(nivelIden + 1);
  			altfel.set_nivelIden(nivelIden + 1);
  			for(int i = 0; i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<IfNode> if" + "\n" + test.toString() + then.toString() + altfel.toString();
  		}
  	}


  	class WhileNode extends Node
  	{
  		private ValueNode test;
  		private Node then;

  		WhileNode(ValueNode test, Node then)
  		{
  			super();
  			this.test = test;
  			this.then = then;
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			test.get_UnassignedVarException();
  			then.get_UnassignedVarException();
  		}


  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			try
  			{
	  			while(Boolean.valueOf(test.get_value()))
  				{
  					then.eval();
  				}
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			test.set_nivelIden(nivelIden + 1);
  			then.set_nivelIden(nivelIden + 1);
  			for(int i = 0; i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<WhileNode> while" + "\n" + test.toString() + then.toString();
  		}
  	}


  	class SequenceNode extends Node
  	{
  		private Node n1, n2;

  		SequenceNode(Node n1, Node n2)
  		{	
  			super();
  			this.n1 = n1;
  			this.n2 = n2;
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			n1.get_UnassignedVarException();
  			n2.get_UnassignedVarException();
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			try
  			{
  				n1.eval();
  				n2.eval();
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString() 
  		{
  			String to_ret = "";
  			n1.set_nivelIden(nivelIden + 1);
  			n2.set_nivelIden(nivelIden + 1);
  			for(int i = 0; i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<SequenceNode>" + "\n" + n1.toString() + n2.toString();
  		}
  	}


  	class BlockNode extends Node
  	{
  		private Node node;

  		BlockNode (Node node)
  		{
  			super();
  			this.node = node;
  		}

  		@Override
		void eval() throws UnassignedVarException, DivideByZeroException
		{
  			try
  			{
  				if(node != null)
  					node.eval();
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			if(node != null)
  				node.get_UnassignedVarException();
  		}  		

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0; i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			if(node != null)
  			{
  				node.set_nivelIden(nivelIden + 1);
  				return to_ret + "<BlockNode> {}" + "\n" + node.toString();
  			}
  			return to_ret + "<BlockNode> {}" + "\n";
  		}
  	}


  	class BracketNode extends ValueNode
  	{
  		private ValueNode node;

  		BracketNode(ValueNode node)
  		{
  			super();
  			this.node = node;
  		}

  		@Override
		void eval() throws UnassignedVarException, DivideByZeroException
		{
  			
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			node.get_UnassignedVarException();
  		}


  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			try{
  				return node.get_value();
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}

  		}

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}

  			node.set_nivelIden(nivelIden + 1);

  			return to_ret + "<BracketNode> ()" + "\n" + node.toString();
  		}
  	}

  	class NotNode extends ValueNode
  	{
  		private ValueNode node;

  		NotNode(ValueNode node)
  		{
  			super();
  			this.node = node;
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			node.get_UnassignedVarException();
  		}


  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			try{
  			return String.valueOf((!(Boolean.valueOf(node.get_value()))));
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}

  			node.set_nivelIden(nivelIden + 1);

  			return to_ret + "<NotNode> !" + "\n" + node.toString();
  		}
  	}

  	class AndNode extends ValueNode
  	{
  		private ValueNode t1;
  		private ValueNode t2;

  		AndNode(ValueNode t1, ValueNode t2)
  		{
  			super();
  			this.t1 = t1;
  			this.t2 = t2;
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			t1.get_UnassignedVarException();
  			t2.get_UnassignedVarException();
  		}


  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			try
  			{
  				return String.valueOf( Boolean.valueOf(t1.get_value()) && Boolean.valueOf(t2.get_value()));
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}

  			t1.set_nivelIden(nivelIden + 1);
  			t2.set_nivelIden(nivelIden + 1);

  			return to_ret + "<AndNode> &&" + "\n" + t1.toString() + t2.toString();
  		}
  	}

  	class GreaterNode extends ValueNode
  	{
  		private ValueNode t1;
  		private ValueNode t2;

  		GreaterNode(ValueNode t1, ValueNode t2)
  		{
  			super();
  			this.t1 = t1;
  			this.t2 = t2;
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			t1.get_UnassignedVarException();
  			t2.get_UnassignedVarException();
  		}


  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			try
  			{
  				return String.valueOf(Integer.valueOf(t1.get_value()) > Integer.valueOf(t2.get_value()));
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}


  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}

  			t1.set_nivelIden(nivelIden + 1);
  			t2.set_nivelIden(nivelIden + 1);

  			return to_ret + "<GreaterNode> >" + "\n" + t1.toString() + t2.toString();
  		}
  	}


  	class PlusNode extends ValueNode
  	{
  		private ValueNode t1;
  		private ValueNode t2;

  		PlusNode(ValueNode t1, ValueNode t2)
  		{
  			super();
  			this.t1 = t1;
  			this.t2 = t2;
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			t1.get_UnassignedVarException();
  			t2.get_UnassignedVarException();
  		}


  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			try
  			{
  				return String.valueOf(Integer.valueOf(t1.get_value()) + Integer.valueOf(t2.get_value()));
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  		}

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}

  			t1.set_nivelIden(nivelIden + 1);
  			t2.set_nivelIden(nivelIden + 1);

  			return to_ret + "<PlusNode> +" + "\n" + t1.toString() + t2.toString();
  		}
  	}

  	class DivNode extends ValueNode
  	{
  		private ValueNode t1;
  		private ValueNode t2;
  		private int line;

  		DivNode(ValueNode t1, ValueNode t2, int line)
  		{
  			super();
  			this.t1 = t1;
  			this.t2 = t2;
  			this.line = line;
  		}

  		@Override 
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
  			t1.get_UnassignedVarException();
  			t2.get_UnassignedVarException();
  		}


  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			try
  			{	if(Integer.valueOf(t2.get_value()) != 0)
  					return String.valueOf(Integer.valueOf(t1.get_value()) / Integer.valueOf(t2.get_value()));
  				throw new DivideByZeroException(line);
  			}
  			catch(UnassignedVarException e)
  			{
  				throw e;
  			}
  			catch(DivideByZeroException e)
  			{
  				throw e;
  			}
  		}

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}

  			t1.set_nivelIden(nivelIden + 1);
  			t2.set_nivelIden(nivelIden + 1);

  			return to_ret + "<DivNode> /" + "\n" + t1.toString() + t2.toString();
  		}
  	}


  	class VarNode extends ValueNode
  	{
  		private String variable;
  		private int line;

  		VarNode(String variable, int line)
  		{
  			super();
  			this.variable = variable;
  			this.line = line;
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		void get_UnassignedVarException() throws UnassignedVarException
  		{
			if(!vars.containsKey(variable))
				throw new UnassignedVarException(line);
	  	}


  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			if(vars.get(variable) != null)
  				return String.valueOf(vars.get(variable));
  			throw new UnassignedVarException(line);
  		}

  		@Override
  		String get_name()
  		{
  			return variable;
  		}

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<VariableNode> " + variable + "\n";
  		}
  	}


  	class IntNode extends ValueNode
  	{
  		private String value;

  		IntNode(String value)
  		{
  			super();
  			this.value = value;
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			return value;
  		}

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<IntNode> " + value + "\n";
  		}
  	}

  	class BoolNode extends ValueNode
  	{
  		private Boolean value;

  		BoolNode(Boolean value)
  		{
  			super();
  			this.value = value;
  		}

  		@Override
  		void eval() throws UnassignedVarException, DivideByZeroException
  		{
  			
  		}

  		@Override
  		public String get_value() throws UnassignedVarException, DivideByZeroException
  		{
  			return String.valueOf(value);
  		}

  		@Override
  		public String toString()
  		{
  			String to_ret = "";
  			for(int i = 0 ;i < nivelIden; i++)
  			{
  				to_ret += "\t";
  			}
  			return to_ret + "<BoolNode> " + value + "\n";
  		}
  	}

%}
 
    LineTerminator = \r|\n|\r\n
    space = " " | "\t"

	digit = [1-9]+
	number = {digit} ( 0 | {digit} )* | 0
 	string = [a-z]+
 	var = {string}
 	AVal = {number}
 	Bval = true | false

 	assign = "="
 	open = "("
 	close = ")"
 	daca = "if"
 	cand = "while"
 	start = "{"
 	end = "}"

 	operatie = "+" | "/" | ">" | "&&" | "!"

%state EGAL
%state INIT_VARS

%%
 
{LineTerminator} { line++; }

"int"   {
			yybegin(INIT_VARS);
		}


{daca} 	{
			conditions.addLast("if");
		}

{cand} 	{
			conditions.addLast("while");
		}

"else" 	{
			conditions.addLast("else");
		}

{start} 
		{
			sequences.addLast(new LinkedList<Node>());
		}
{end}
		{
			LinkedList<Node> comenzi = sequences.removeLast();
			int n = comenzi.size();
			if(n == 0)
			sequences.peekLast().addLast(new BlockNode(null));
			if(n == 1)
			{
				sequences.peekLast().addLast(new BlockNode(comenzi.removeLast()));
			}
			if(n >= 2)
			{
				Node n2 = comenzi.removeLast();
				Node n1 = comenzi.removeLast();
				SequenceNode last = new SequenceNode(n1, n2);
				for(int i = 1 ; i < n - 1 ;i++)
				{
					last = new SequenceNode(comenzi.removeLast(), last);
				}
				sequences.peekLast().addLast(new BlockNode(last));
			}
			String conditie = conditions.peekLast();
			if(conditie.equals("else"))
			{
				conditions.removeLast();
				// Ar trebui sa fie mereu un if aici
				conditions.removeLast();
				Node altfel = sequences.peekLast().removeLast();
				Node then = sequences.peekLast().removeLast();
				sequences.peekLast().addLast(new IfNode(values.removeLast(), then, altfel));
			}
			if(conditie.equals("while"))
			{
				conditions.removeLast();
				sequences.peekLast().addLast(new WhileNode(values.removeLast(), sequences.peekLast().removeLast()));
			}
		}

{open} {operators.push("(");}

{assign}	{
				operators.push("=");
				variable_to_assign = values.pollLast();
				yybegin(EGAL);
			}

{operatie}
		{

			int prior1 = priority.get(yytext());

			while(!operators.empty() && !operators.peek().equals("(") && !operators.peek().equals("="))
			{
				String op = operators.pop();
				int prior2 = priority.get(op);
				if(prior2 >= prior1)
				{
					make_value_node(op);
				}
				else
				{
					operators.push(op);
					break;
				}
			}
			operators.push(yytext());
		}

{close}

		{
			String op;
			while(!operators.peek().equals("("))
			{
				op = operators.pop();
				make_value_node(op);
			}
			operators.pop();
			values.addLast(new BracketNode(values.removeLast()));
		}

{Bval} {values.addLast(new BoolNode(Boolean.valueOf(yytext())));}


<YYINITIAL>
			{
				{var} {values.addLast(new VarNode(yytext(), yyline + 1));}
			}
{AVal} {values.addLast(new IntNode(yytext()));}
//TODO: make string in case of failure :)

<EGAL>
{

	{var} {values.addLast(new VarNode(yytext(), yyline + 1));}

	";" {
			String op;
			while(!((op = operators.pop()).equals("=")))
			{
				make_value_node(op);
			}

			sequences.peekLast().addLast(new AssignmentNode(variable_to_assign, values.pollLast(), yyline + 1));
			yybegin(YYINITIAL);
		}
}

<INIT_VARS>
			{

				{var}
					{
						vars.put(yytext(), null);
					}

				"," {}

				";" { 
						init();
						yybegin(YYINITIAL);
					}
			}

<<EOF>> {
			LinkedList<Node> seq = sequences.pop();
			int n = seq.size();
			boolean error = false;
			if(n == 1)
			{
				main_node = new MainNode(seq.pop());
			}

			if(n >= 2)
			{
				Node n2 = seq.removeLast();
				Node n1 = seq.removeLast();
				SequenceNode last = new SequenceNode(n1, n2);
				for(int i = 1; i < n -1; i++)
				{
					n1 = seq.removeLast();
					last = new SequenceNode(n1, last);
				}
				main_node = new MainNode(last);
				
			}
			BufferedWriter arbore = new BufferedWriter(new FileWriter("arbore"));
			BufferedWriter output = new BufferedWriter(new FileWriter("output"));
			arbore.write(main_node.toString());
			arbore.close();
			try{
				main_node.get_UnassignedVarException();
				main_node.eval();
			}
			catch(UnassignedVarException e)
			{
				output.write(e.getMessage());
				output.newLine();
				output.close();
				error = true;
			}
			catch(DivideByZeroException e)
			{
				output.write(e.getMessage());
				output.newLine();
				output.close();
				error = true;
			}

			if(!error)
			{
				Iterator<Map.Entry<String, Integer>> it = vars.entrySet().iterator();
				while(it.hasNext())
				{
					Map.Entry<String, Integer> temp = it.next();
					output.write(temp.getKey() + "=" + temp.getValue());
					output.newLine();
				}
				output.close();
			}
			return 0;
		}

{space} {}