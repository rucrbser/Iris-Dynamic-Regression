library(shiny)

shinyUI(fluidPage(
        titlePanel("Iris Dynamic Linear Regression"),
        sidebarLayout(
                sidebarPanel(
                        tabsetPanel(type = "tabs",
                                    tabPanel("Dynamic Linear Regression between Sepal",
                                             sliderInput("Samples",
                                                         "How many samples do you want to sample from iris dataset?",
                                                         min = 2,
                                                         max = 150,
                                                         value = 75)), 
                                    tabPanel("Dynamic Linear Regression between Petal",
                                             numericInput("Samples2",
                                                          "How many samples do you want to sample from iris dataset?
                                                          (Please input between 2 and 150!)",
                                                          value = 75,
                                                          min = 2,
                                                          max = 150,
                                                          step = 1))),
                        checkboxInput("showModel1", "Show/Hide Linear Model", value = TRUE),
                        checkboxInput("showModel2", "Show/Hide Smoothing Model", value = FALSE)
                        
                ),
                mainPanel(
                        tabsetPanel(type = "tabs",
                                    tabPanel("Dynamic Linear Regression between Sepal", 
                                             plotOutput("LinearRegPlot"), 
                                             h3("The Average Squared Residual of the Linear Model(red line) is:"), 
                                             textOutput("LinearRegResid")),
                                    tabPanel("Dynamic Linear Regression between Petal", 
                                             plotOutput("LinearRegPlot2"), 
                                             h3("The Average Squared Residual of the Linear Model(red line) is:"), 
                                             textOutput("LinearRegResid2"))
                        )
                        
                )
        )
))
