#build: 
#	java -Xmx500M -cp "/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool Parser.g4 -visitor
#	javac *.java
	#jar cfe tema.jar Main *.class

#run: 
#	java Main input

#clean:
#	rm *.class
	#rm JFlex/Parser.java
build:
	java -jar antlr-4.7.1-complete.jar Parser.g4 -visitor
	javac -cp ./antlr-4.7.1-complete.jar *.java

run:
	java -cp .:antlr-4.7.1-complete.jar Main input1

clean:
	rm *.class *.interp *.tokens Parser*.java
