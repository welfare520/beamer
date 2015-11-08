# NPS analysis 
rm(list = ls())
library(tm)
library(data.table)

args<-commandArgs(TRUE)
# d.comment = 'I do not like football. I have a BMW car. I am living in Berlin'
d.comment = gsub(pattern='\\s', replacement=" ", x=readChar(as.character(args[1]),nchars=1e6))
reuters <- VCorpus(VectorSource(d.comment))

reuters <- tm_map(reuters, tolower) 
reuters <- tm_map(reuters, removePunctuation)
reuters <- tm_map(reuters, stripWhitespace)
reuters <- tm_map(reuters, PlainTextDocument)
reuters <- tm_map(reuters, removeWords, stopwords("english"))
reuters <- tm_map(reuters, removePunctuation)
reuters <- tm_map(reuters, removeWords, c("like"))

tags <- DocumentTermMatrix(reuters)$dimnames$Terms

print(tags)

# dtm <- removeSparseTerms(DocumentTermMatrix(reuters), 0.99)
# fsets <- eclat(as.matrix(dtm), parameter = list(supp = 0.003, minlen=2))
# fsets.top10 <- SORT(fsets)[1:10]
# 
# detach(package:tm, unload=TRUE)