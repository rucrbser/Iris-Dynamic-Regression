library(shiny)

shinyServer(function(input, output) {
        numsample <- reactive({
                input$Samples
        })
        
        numsample2 <- reactive({
                input$Samples2
        })
        
        newiris <- reactive({
                iris[sample(dim(iris)[1], numsample()), ]
        })
        
        newiris2 <- reactive({
                iris[sample(dim(iris)[1], numsample2()), ]
        })
        
        fit <- reactive({
                lm(Petal.Width ~ Petal.Length, data = newiris())
        })
        
        fit2 <- reactive({
                lm(Sepal.Width ~ Sepal.Length, data = newiris2())
        })
        
        PetalWidthhat <- reactive({
                knots <- seq(min(newiris()$Petal.Length), max(newiris()$Petal.Length), length = 3)
                splineTerms <- sapply(knots, function(knot) 
                        (newiris()$Petal.Length > knot) * (newiris()$Petal.Length - knot)^3)
                PetalLengthMat <- cbind(1, newiris()$Petal.Length, newiris()$Petal.Length^2, 
                                        newiris()$Petal.Length^3, splineTerms)
                predict(lm(Petal.Width ~ PetalLengthMat - 1, data = newiris()))
        })
        
        SepalWidthhat <- reactive({
                knots <- seq(min(newiris2()$Sepal.Length), max(newiris2()$Sepal.Length), length = 3)
                splineTerms <- sapply(knots, function(knot) 
                        (newiris2()$Sepal.Length > knot) * (newiris2()$Sepal.Length - knot)^3)
                SepalLengthMat <- cbind(1, newiris2()$Sepal.Length, newiris2()$Sepal.Length^2, 
                                        newiris2()$Sepal.Length^3, splineTerms)
                predict(lm(Sepal.Width ~ SepalLengthMat - 1, data = newiris2()))
        })
        
        output$LinearRegPlot <- renderPlot({
                with(newiris(), plot(Petal.Length, Petal.Width, pch = 20))
                if(input$showModel1) {
                        abline(fit(), col = "red", lwd = 4)
                }
                if(input$showModel2) {
                        lines(newiris()$Petal.Length, PetalWidthhat(), col = "blue")  
                }
        })
        
        output$LinearRegPlot2 <- renderPlot({
                with(newiris2(), plot(Sepal.Length, Sepal.Width, pch = 20))
                if(input$showModel1) {
                        abline(fit2(), col = "red", lwd = 4)
                }
                if(input$showModel2) {
                        lines(newiris2()$Sepal.Length, SepalWidthhat(), col = "blue")  
                }
        })
        
        output$LinearRegResid <- renderText({
                if(numsample() == 2) {
                        "No Residual!"
                } else {
                        sqrt(sum(resid(fit()) ^ 2) / (numsample() - 2))
                }
        })
        
        output$LinearRegResid2 <- renderText({
                if(numsample2() == 2) {
                        "No Residual!"
                } else {
                        sqrt(sum(resid(fit2()) ^ 2) / (numsample2() - 2))
                }
        })
})
