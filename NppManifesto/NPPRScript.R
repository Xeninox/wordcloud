# Manifesto.R, cwj, 11/3/2016
# demo on how to do Manifesto Analysis
# based on http://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining
# to be done in recitation
#
# load in the text mining package
library(tm)
#
# connect to the directory
setwd("~/NppManifesto")
library("RColorBrewer")
#
# load in the pdf files that hold the Manifestos
# (we did this manually, but see if you can find
#  an automatic method using R!)
#
files <- list.files(pattern="pdf$")
files
#
# defining Reader for pdf files
Rpdf <- readPDF(control = list(text = "-layout"))
#
# prepare to say we are in Accra for time zone purposes
Sys.setenv(TZ="GMT")
#
# read in all the Manifestos at a go
Manifesto <- Corpus(URISource(files),
                     readerControl = list(reader = Rpdf))

#Manifestos <- tm_map(Manifestos, removeWords, c("the", "and", "will", "that", "are", 
#                                                "also", "other", "its", "has", "have", 
#                                                "this", "from", "into", "over")) 
#
# create the TDM
Manifesto.tdm <- TermDocumentMatrix(Manifesto, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  removeNumbers = TRUE,
  bounds = list(global = c(1, Inf))))
#
# preview the top ten terms across the Manifestos
inspect(Manifesto.tdm[1:10,])
#
# find the top ten most frequent words across the Manifestos
findFreqTerms(Manifesto.tdm, lowfreq=100, highfreq=Inf)
#
# load wordcloud package to draw wordcloud
library(wordcloud)
#
# put together wordcloud of whole corpus
wordcloud(Manifesto, max.words=30, colors=brewer.pal(8, "Dark2"))

#making a barplot of the most frequently used words
manifestoMatrix <- as.matrix(Manifesto.tdm)
manifestoVector <- sort(rowSums(manifestoMatrix),decreasing=TRUE)
dataFrame <- data.frame(word = names(manifestoVector),frequency=manifestoVector)
head(dataFrame, 10)
barplot(dataFrame[1:10,]$frequency, las = 2, names.arg = dataFrame[1:10,]$word,
        col ="red", main ="Top Ten Words",
        ylab = "Frequencies")
