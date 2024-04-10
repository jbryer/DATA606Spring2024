year <- 2024
semester <- 'Spring'
github_link <- "DATA606Spring2024"
one_minute_paper <- 'https://forms.gle/Jcw55CYvc6Ym8A5F7'
one_minute_paper_results <- "https://docs.google.com/spreadsheets/d/1zpSctUcCJvZpu52ZOc2OMF_2mCNrMZFVKiA9-rhlHUA/edit?resourcekey#gid=232744019"
formative_assessment <- 'https://forms.gle/ywT9xeUDyRx6AhMbA'
formative_assessmnet_results <- 'https://docs.google.com/spreadsheets/d/1oHoO8d5FzlgHsagYOgzS5duaTJRVMrORebqF_JsFYhc/edit?resourcekey#gid=82996459'
slack_invite_link <- 'https://join.slack.com/t/cuny-96b6194/shared_invite/zt-2apyhbeq8-h2XHc3syAWw2BME1V7m41w'
slack_link <- 'https://DATA606Spring2024.slack.com'

# remotes::install_github("ropenscilabs/icon")
# remotes::install_github("gadenbuie/countdown", subdir = "r")
# icons::download_fontawesome()
# remotes::install_github("thomasp85/patchwork")

library("knitr")
library("tidyverse")
# library("countdown")
library("likert")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("VisualStats")
library("DATA606")
library("reshape2")
library("latex2exp")
library("psych")
library("cowplot")
library("rmarkdown")
library("qrcode")

library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

opts_chunk$set(digits = 3, width = 120)

knitr::opts_chunk$set(warning = FALSE, message = FALSE, error = FALSE,
					  fig.width = 12, fig.height=6, fig.align = 'center',
					  digits = 3)

# The following is to fix a DT::datatable issue with Xaringan
# https://github.com/yihui/xaringan/issues/293
options(htmltools.dir.version = FALSE, htmltools.preserve.raw = FALSE)

# This style was adapted from Max Kuhn: https://github.com/rstudio-conf-2020/applied-ml
# And Rstudio::conf 2020: https://github.com/rstudio-conf-2020/slide-templates/tree/master/xaringan
# This slide deck shows a lot of the features of Xaringan: https://www.kirenz.com/slides/xaringan-demo-slides.html

# To use, add this to the slide title:   `r I(hexes(c("DATA606")))`
# It will use images in the images/hex_stickers directory (i.e. the filename is the parameter)
hexes <- function(x) {
	x <- rev(sort(x))
	markup <- function(pkg) glue::glue('<img src="images/hex/{pkg}.png" class="title-hex">')
	res <- purrr::map_chr(x, markup)
	paste0(res, collapse = "")
}

printLaTeXFormula <- function(fit, digits=2) {
	vars <- all.vars(fit$terms)
	result <- paste0('\\hat{', vars[1], '} = ', prettyNum(fit$coefficients[[1]], digits=2))
	for(i in 2:length(vars)) {
		val <- fit$coefficients[[i]]
		result <- paste0(result, ifelse(val < 0, ' - ', ' + '),
						 prettyNum(abs(val), digits=digits),
						 ' ', names(fit$coefficients)[i])
	}
	return(result)
}

PlotDist <- function(alpha, from = -5, to = 5, n = 1000, filename = NULL,
					 alternative = c("two.tailed", "greater", "lesser"),
					 distribution = c("normal", "t", "F", "chisq", "binomial"),
					 colour = "black", fill = "skyblue2",
					 ...)
{
	alternative <- match.arg(alternative)
	alt.alpha <- switch(alternative, two.tailed = alpha/2, greater = alpha,
						lesser = alpha)
	MyDen <- switch(distribution, normal = dnorm, t = dt, F = df,
					chisq = dchisq, binomial = dbinom)
	MyDist <- switch(distribution, normal = qnorm, t = qt, F = qf,
					 chisq = qchisq, binomial = qbinom)
	crit.lower <- MyDist(p = alt.alpha, lower.tail = TRUE, ...)
	crit.upper <- MyDist(p = alt.alpha, lower.tail = FALSE, ...)
	cord.x1 <- c(from, seq(from = from, to = crit.lower, length.out = 100),
				 crit.lower)
	cord.y1 <- c(0, MyDen(x = seq(from = from, to = crit.lower,
								  length.out = 100), ...), 0)
	cord.x2 <- c(crit.upper, seq(from = crit.upper, to = to,
								 length.out = 100), to)
	cord.y2 <- c(0, MyDen(x = seq(from = crit.upper, to = to,
								  length.out = 100), ...), 0)
	if (!is.null(filename)) pdf(file = filename)
	curve(MyDen(x, ...), from = from, to = to, n = n, col = colour,
		  lty = 1, lwd = 2, ylab = "Density", xlab = "Values")
	if (!identical(alternative, "greater")) {
		polygon(x = cord.x1, y = cord.y1, col = fill)
	}
	if (!identical(alternative, "lesser")) {
		polygon(x = cord.x2, y = cord.y2, col = fill)
	}
	if (!is.null(filename)) dev.off()
}

ompWordCloud <- function(text) {
	if(length(text) < 1) {
		warning('No text to create a word cloud.')
		return()
	}
	docs <- Corpus(VectorSource(text))
	# Convert the text to lower case
	docs <- tm_map(docs, content_transformer(tolower))
	# Remove numbers
	docs <- tm_map(docs, removeNumbers)
	# Remove english common stopwords
	docs <- tm_map(docs, removeWords, stopwords("english"))
	# Remove your own stop word
	# specify your stopwords as a character vector
	docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))
	# Remove punctuations
	docs <- tm_map(docs, removePunctuation)
	# Eliminate extra white spaces
	docs <- tm_map(docs, stripWhitespace)
	dtm <- TermDocumentMatrix(docs)
	m <- as.matrix(dtm)
	v <- sort(rowSums(m),decreasing=TRUE)
	d <- data.frame(word = names(v),freq=v)
	head(d, 10)
	wordcloud(words = d$word, freq = d$freq, min.freq = 2,
			  max.words=200, random.order=FALSE, rot.per=0.35,
			  colors=brewer.pal(8, "Dark2"))
}
