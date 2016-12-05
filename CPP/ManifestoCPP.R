#Group C Data Mining Project
#Jeffrey Takyi-Yeboah 
#40532017
#Script to run CPP manifesto

# load in the text mining package
library(tm)
#
# connect to the directory
setwd("/Users/JeffreyTakyi-Yeboah/Desktop/Desktop/wordcloud/CPP")


library("RColorBrewer")
files <- list.files(pattern="pdf$")

# list out the files that were laoded into the system
files

# defining Reader for pdf files
Rpdf <- readPDF(control = list(text = "-layout"))

# set the timezone
Sys.setenv(TZ="GMT")

# read in all the Manifestos at a go
Manifestos <- Corpus(URISource(files),
                     readerControl = list(reader = Rpdf))

# create the term document matrix
Manifestos.tdm <- TermDocumentMatrix(Manifestos, control = list(
  removePunctuation = TRUE,
  stopwords = TRUE,
  tolower = TRUE,
  stemming = FALSE,
  removeNumbers = TRUE,
  bounds = list(global = c(1, Inf))))

# preview the top ten terms across the Manifestos
inspect(Manifestos.tdm[1:10,])

# find the top ten most frequent words across the Manifestos
findFreqTerms(Manifestos.tdm, lowfreq=100, highfreq=Inf)
#
# load wordcloud package to draw wordcloud
library(wordcloud)

# put together wordcloud of whole corpus
wordcloud(Manifestos, max.words=40, colors=brewer.pal(8, "Dark2"))

#making a barplot of the most frequently used words
manifestoMatrix <- as.matrix(Manifestos.tdm)
manifestoVector <- sort(rowSums(manifestoMatrix),decreasing=TRUE)
dataFrame <- data.frame(word = names(manifestoVector),frequency=manifestoVector)
head(dataFrame, 10)
barplot(dataFrame[1:10,]$frequency, las = 2, names.arg = dataFrame[1:10,]$word,
        col ="grey", main ="Top Ten Words",
        ylab = "Frequencies")