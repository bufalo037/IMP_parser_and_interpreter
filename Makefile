build: 
	jflex parser.flex
	javac Parser.java
	javac Main.java
	#rm JFlex/Parser.java~
	#jar cfe tema.jar JFlex.Main JFlex/*.class

run: 
	#java -jar tema.jar
	java Main
clean:
	rm 	*.class
	#rm tema.jar
	#rm JFlex/Parser.java