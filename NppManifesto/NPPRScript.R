# NPPManifesto.R, Maame Yaa Afriyie Poku 12/3/2016
# NPP Manifesto Analysis
# based on http://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining
# to be done in recitation
#
# load in the text mining package
library(tm)
#
# connect to the directory
setwd("~/NppManifesto")

# to add color to the wordcloud
library("RColorBrewer")
#
# load in the pdf files that hold the Manifesto
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
# create the TDM
Manifesto.tdm <- TermDocumentMatrix(Manifesto, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  removeNumbers = TRUE,
  bounds = list(global = c(1, Inf))))
#
# preview the top ten terms in the Manifesto
inspect(Manifesto.tdm[1:10,])
#
# find the top ten most frequent words in the Manifesto
findFreqTerms(Manifesto.tdm, lowfreq=100, highfreq=Inf)
#
# load wordcloud package to draw wordcloud
library(wordcloud)
#
# put together wordcloud of whole corpus
wordcloud(Manifesto, max.words=30, colors=brewer.pal(8, "Dark2"))

# make a barplot of the most frequently used words
manifestoMatrix <- as.matrix(Manifesto.tdm)
manifestoVector <- sort(rowSums(manifestoMatrix),decreasing=TRUE)
dataFrame <- data.frame(word = names(manifestoVector),frequency=manifestoVector)
head(dataFrame, 10)
barplot(dataFrame[1:10,]$frequency, las = 2, names.arg = dataFrame[1:10,]$word,
        col ="red", main ="Top Ten Words",
        ylab = "Frequencies")
