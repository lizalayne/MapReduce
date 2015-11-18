#
# This is a simple makefile to assist with quickly building the Exercises of MP2.
#
# To build and execute a particular exercise:
#    - For a single exercise, type 'make runA' to run exercise A.
#    - For all exercises, 'make'.
#
#
HADOOP_CLASSPATH := ${JAVA_HOME}/lib/tools.jar
export HADOOP_CLASSPATH

HDFS=PSO

OBJDIR=build

JAR := MapReducePSO.jar

TARGETS := $(addprefix run, A B C D E F)

.PHONY: final $(TARGETS) clean

final: $(TARGETS)

runA: $(OBJDIR)/TitleCount.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/A-output/
	hadoop jar $(JAR) TitleCount -D stopwords=/$(HDFS)/misc/stopwords.txt -D delimiters=/$(HDFS)/misc/delimiters.txt /$(HDFS)/titles /$(HDFS)/A-output
	@echo "Run the following command to read the output file:"
	@echo "hadoop fs -cat /$(HDFS)/A-output/part*"

runB: $(OBJDIR)/TopTitles.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/B-output/
	hadoop jar $(JAR) TopTitles -D stopwords=/$(HDFS)/misc/stopwords.txt -D delimiters=/$(HDFS)/misc/delimiters.txt -D N=5 /$(HDFS)/titles /$(HDFS)/B-output
	@echo "Run the following command to read the output file:"
	@echo "\t hadoop fs -cat /$(HDFS)/B-output/part*"

runC: $(OBJDIR)/TopTitleStatistics.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/C-output/
	hadoop jar $(JAR) TopTitleStatistics -D stopwords=/$(HDFS)/misc/stopwords.txt -D delimiters=/$(HDFS)/misc/delimiters.txt -D N=5 /$(HDFS)/titles /$(HDFS)/C-output
	@echo "Run the following command to read the output file:"
	@echo "\t hadoop fs -cat /$(HDFS)/C-output/part*"

runD: $(OBJDIR)/OrphanPages.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/D-output/
	hadoop jar $(JAR) OrphanPages /$(HDFS)/links /$(HDFS)/D-output
	@echo "Run the following command to read the output file:"
	@echo "\t hadoop fs -cat /$(HDFS)/D-output/part*"

runE: $(OBJDIR)/TopPopularLinks.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/E-output/
	hadoop jar $(JAR) TopPopularLinks -D N=5 /$(HDFS)/links /$(HDFS)/E-output
	@echo "Run the following command to read the output file:"
	@echo "\t hadoop fs -cat /$(HDFS)/E-output/part*"

runF: $(OBJDIR)/PopularityLeague.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/F-output/
	hadoop jar $(JAR) PopularityLeague -D league=/$(HDFS)/misc/league.txt /$(HDFS)/links /$(HDFS)/F-output
	@echo "Run the following command to read the output file:"
	@echo "\t hadoop fs -cat /$(HDFS)/F-output/part*"


$(OBJDIR)/%.class: %.java | $(OBJDIR)
	hadoop com.sun.tools.javac.Main $< -d $(OBJDIR)

$(OBJDIR):
	mkdir $@

.PHONY: clean
clean:
	rm -f $(OBJDIR)/* $(JAR)
	hadoop fs -rm -r -f /$(HDFS)/*-output/
