library(shiny)
library(tidyverse)
data(mtcars)

ui <- fluidPage(
	titlePanel("Linear Regression with mtcars"),
	sidebarLayout(
	  sidebarPanel(
	  	selectInput('x', 'Independent Variable',
	  				choices = names(mtcars),
	  				selected = 'wt'),
	  	selectInput('y', 'Dependent Variable',
	  				choices = names(mtcars),
	  				selected = 'mpg')
	  ),

	  mainPanel(
	  	tabsetPanel(
	  		tabPanel("Plot", plotOutput("plot")),
	  		tabPanel("Summary", verbatimTextOutput("summary")),
	  		tabPanel("Table", tableOutput("table"))
	  	)
	  )
	)
)

server <- function(input, output) {
	output$plot <- renderPlot({
		ggplot(mtcars, aes_string(x = input$x, y = input$y)) +
			geom_smooth(method = 'lm', formula = y ~ x, se = FALSE) +
			geom_point()
	})

	output$summary <- renderPrint({
		lm(as.formula(paste0(input$y, ' ~ ', input$x)), data = mtcars) %>% summary()
	})

	output$table <- renderTable({
		mtcars
	})
}

shinyApp(ui = ui, server = server)
