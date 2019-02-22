//package JFlex;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
//import JFlex.Parser;

public class Main
{
	public static void main(String [] args)
	{
		Parser pars = null;
		try
		{
			//pars = new Parser(new FileReader(args[0]));
			pars = new Parser(new FileReader("input"));
		}
		catch(FileNotFoundException e)
		{
			//System.out.println(e.toString());
		}
 		
 		try
 		{
 			pars.yylex();
 		}
 		catch(IOException e)
 		{
 			//System.out.println(e.toString());
 		}
 
    	//System.out.println("numere:" + pars.numbers);
    	//System.out.println("strings:" + pars.strings);
    	//System.out.println("merge:" + pars.merge);
	}
}