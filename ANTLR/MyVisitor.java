import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import java.lang.Integer;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * This class provides an empty implementation of {@link ParserVisitor},
 * which can be extended to create a visitor which only needs to handle a subset
 * of the available methods.
 *
 * @param <Integer> The return type of the visit operation.
 */
public class MyVisitor extends  ParserBaseVisitor<Integer>{
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	BufferedWriter bw = null;
	private int tabs = 0;

    // Functie rudimentara pentru a printa tab-uri
    private void printTabs() {
        for (int i = 0; i < this.tabs; i++) {
            try {
                bw.write("\t");
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

	@Override public Integer visitInteger(ParserParser.IntegerContext ctx) { 
		this.printTabs();
		try
		{
			bw.write("<IntNode> " + ctx.getText());
			bw.newLine();
		}
		catch(IOException e)
		{
			
		}		
		return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitVar(ParserParser.VarContext ctx) { 
            try {
                this.printTabs();
                bw.write("<VariableNode> " + ctx.getText());
                bw.newLine(); 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitValue(ParserParser.ValueContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitEmptyblock(ParserParser.EmptyblockContext ctx) { 
            try {
                this.printTabs();
                bw.write("<BlockNode> {}");
                bw.newLine();  
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitBlock1(ParserParser.Block1Context ctx) { 
            try {
                this.printTabs();
                bw.write("<BlockNode> {}");
                bw.newLine();
                this.tabs++;
                visitChildren(ctx);
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitDaca(ParserParser.DacaContext ctx) { 
            try {
                this.printTabs();
                bw.write("<IfNode> if");
                bw.newLine();
                this.tabs++;
                visit(ctx.bxpr());
                visit(ctx.block(0));
                visit(ctx.block(1));
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitDiv(ParserParser.DivContext ctx) { 
            try {
                this.printTabs();
                bw.write("<DivNode> /");
                bw.newLine();
                this.tabs++;
                visit(ctx.axpr(0));
                visit(ctx.axpr(1));
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitParanthesisA(ParserParser.ParanthesisAContext ctx) { 
            try {
                this.printTabs();
                bw.write("<BracketNode> ()");
                bw.newLine();
                this.tabs++;
                visit(ctx.axpr());
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitValueNode(ParserParser.ValueNodeContext ctx) {  
		return visitChildren(ctx); 
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitPlus(ParserParser.PlusContext ctx) { 
            try {
                this.printTabs();
                bw.write("<PlusNode> +");
                bw.newLine();
                this.tabs++;
                visit(ctx.axpr(0));
                visit(ctx.axpr(1));
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitBool(ParserParser.BoolContext ctx) { 
            try {
                this.printTabs();
                bw.write("<BoolNode> " + ctx.getText());
                bw.newLine(); 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitNot(ParserParser.NotContext ctx) {  
            try {
                this.printTabs();
                bw.write("<NotNode> !");
                bw.newLine();
                this.tabs++;
                visit(ctx.bxpr());
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitAnd(ParserParser.AndContext ctx) {  
            try {
                this.printTabs();
                bw.write("<AndNode> &&");
                bw.newLine();
                this.tabs++;
                visit(ctx.bxpr(0));
                visit(ctx.bxpr(1));
                this.tabs--;  
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitBoolNode(ParserParser.BoolNodeContext ctx) {return visitChildren(ctx);}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitParanthesisB(ParserParser.ParanthesisBContext ctx) { 
            try {
                this.printTabs();
                bw.write("<BracketNode> ()");
                bw.newLine();
                this.tabs++;
                visit(ctx.bxpr());
                this.tabs--; 
                return 0;
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitGreater(ParserParser.GreaterContext ctx) {  
            try {
                this.printTabs();
                bw.write("<GreaterNode> >");
                bw.newLine();
                this.tabs++;
                visit(ctx.axpr(0));
                visit(ctx.axpr(1));
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitStmt(ParserParser.StmtContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitSequence(ParserParser.SequenceContext ctx) {  
            try {
                this.printTabs();
                bw.write("<SequenceNode>");
                bw.newLine();
                this.tabs++;
                visit(ctx.getChild(0));
                visit(ctx.getChild(1));
                this.tabs--; 
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	} 
	
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitVarlist(ParserParser.VarlistContext ctx) { return 0; }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitProg(ParserParser.ProgContext ctx) { 
            try {
            	bw = new BufferedWriter(new FileWriter("arbore"));
                this.printTabs();
                bw.write("<MainNode>");
                bw.newLine();
                this.tabs++;
                visitChildren(ctx);
                this.tabs--;  
                bw.close();
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }

        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitAssign(ParserParser.AssignContext ctx) { 
            try {
                this.printTabs();
                bw.write("<AssignmentNode> =");
                bw.newLine();
                this.tabs++;
                visit(ctx.var());
                visit(ctx.axpr());
                this.tabs--;  
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public Integer visitCand(ParserParser.CandContext ctx) { 
            try {
                this.printTabs();
                bw.write("<WhileNode> while");
                bw.newLine();
                this.tabs++;
                visit(ctx.bxpr());
                visit(ctx.block());
                this.tabs--;  
                
            } catch (IOException ex) {
                Logger.getLogger(MyVisitor.class.getName()).log(Level.SEVERE, null, ex);
            }
        return 0;
	}
}