#NPP_Rscript, Maame YAa Afriyie Poku, 12/4/2016
# NPP Manifesto Analysis
# based on http://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining
# to be done in recitation
#
# load in the text mining package
library(tm)
#
# connect to the directory
setwd("~/NppManifesto")

#to allow us to add color to the word cloud
library("RColorBrewer")
#
# load in the pdf file that holds the Manifesto
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
# read in the Manifestos NPP manifesto
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
# preview the top ten terms across the Manifesto
inspect(Manifesto.tdm[1:10,])
#
# find the top ten most frequent words across the Manifesto
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
