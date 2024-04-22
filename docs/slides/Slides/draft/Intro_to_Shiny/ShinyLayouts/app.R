library(shiny)

ui <- navbarPage('Shiny Layouts',
    tabPanel('Columns',
             fluidRow(
                 column(1, p('Row 1 Column 1')),
                 column(1, p('Row 1 Column 2')),
                 column(1, p('Row 1 Column 3')),
                 column(1, p('Row 1 Column 4')),
                 column(1, p('Row 1 Column 5')),
                 column(1, p('Row 1 Column 6')),
                 column(1, p('Row 1 Column 7')),
                 column(1, p('Row 1 Column 8')),
                 column(1, p('Row 1 Column 9')),
                 column(1, p('Row 1 Column 10')),
                 column(1, p('Row 1 Column 11')),
                 column(1, p('Row 1 Column 12')),
             ),
             fluidRow(
                 column(4, p('Row 1 3 columns')),
                 column(4, p('Row 1 3 columns')),
                 column(4, p('Row 1 3 columns'))
             )
    )
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
