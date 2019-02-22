// Multumim echipei de CPL pentru acest schelet Main

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {

        ParserLexer lexer = null;
        CommonTokenStream tokenStream = null;
        ParserParser parser = null;
        ParserRuleContext globalTree = null;

        // True if any lexical or syntax errors occur.
        boolean lexicalSyntaxErrors = false;

        // Deschidem fisierul input pentru a incepe parsarea
        String fileName = "input";
        CharStream input = CharStreams.fromFileName(fileName);

        // Definim Lexer-ul
        lexer = new ParserLexer(input);

        // Obtinem tokenii din input
        tokenStream = new CommonTokenStream(lexer);

        // Definim Parser-ul
        parser = new ParserParser(tokenStream);

        // Incepem parsarea
        ParserRuleContext tree = parser.prog();

        // Vizitam AST-ul
        MyVisitor visitor = new MyVisitor();
        visitor.visit(tree);
    }
}
