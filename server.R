# This file defines the back-end of the application
# server-side functionality

# importing shiny library
library(shiny)

# importing HACSim library
library(HACSim)

# importing ggplot2
library(ggplot2)
library(stringr)
library(shinymeta)
library(shinyjs)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observeEvent(input$run, {
    # Main interface variables
    perms <- input$perms
    p <- input$p
    conf.level <- input$conf.level
    progress <- input$progress_bar
    
    if (is.na(input$num.iters)) {
      num.iters <- as.null(input$num.iters)
    } else {
      num.iters <- input$num.iters
    }
    
    # fasta <- input$fastafile
    # ext <- tools::file_ext(fasta$datapath)
    #   
    # req(fasta)
    # validate(need(ext == c("fas", "fasta"), "Please upload a FASTA file"))
    # seqs <- read.dna(file = fasta$datapath, format = "fasta")
    
    # find if simulation type is real or hypothetical
    if(input$switch == TRUE){  # Real
   
      if(input$Id015 == TRUE){ # Preloaded example
        
        values <- reactiveValues()
        N <- input$N_load_a
        Hstar <- input$Hstar_load_a
        x <- input$probs_load_a
        split_str <- strsplit(x, ",")
        probs <- as.numeric(unlist(split_str))
        
        if(input$Id008 == 'Lake whitefish (Coregonus clupeaformis)'){
          N <- input$N_load_a
          Hstar <- input$Hstar_load_a
          x <- input$probs_load_a
          split_str <- strsplit(x, ",")
          probs <- as.numeric(unlist(split_str))
          subsample <- input$subsampleseqs
          prop = input$prop
          evaluate <- TRUE
          if(subsample == TRUE && is.na(prop) == TRUE){
            evaluate <- FALSE
          }else if(subsample == TRUE && (prop < 0 || prop > 1)){
            evaluate <- FALSE
          }
        }else if(input$Id008 == 'Pea aphid (Acyrthosiphon pisum)'){
          N <- input$N_load_b
          Hstar <- input$Hstar_load_b
          x <- input$probs_load_b
          split_str <- strsplit(x, ",")
          probs <- as.numeric(unlist(split_str))
          subsample <- input$subsampleseqs
          prop = input$prop
          evaluate <- TRUE
          if(subsample == TRUE && is.na(prop) == TRUE){
            evaluate <- FALSE
          }else if(subsample == TRUE && (prop < 0 || prop > 1)){
            evaluate <- FALSE
          }
        }else if(input$Id008 == 'Common mosquito (Culex pipiens)'){
          N <- input$N_load_c
          Hstar <- input$Hstar_load_c
          x <- input$probs_load_c
          split_str <- strsplit(x, ",")
          probs <- as.numeric(unlist(split_str))
          subsample <- input$subsampleseqs
          prop = input$prop
          evaluate <- TRUE
          if(subsample == TRUE && is.na(prop) == TRUE){
            evaluate <- FALSE
          }else if(subsample == TRUE && (prop < 0 || prop > 1)){
            evaluate <- FALSE
          }
        }else if(input$Id008 == 'Deer tick (Ixodes scapularis)'){
          N <- input$N_load_d
          Hstar <- input$Hstar_load_d
          x <- input$probs_load_d
          split_str <- strsplit(x, ",")
          probs <- as.numeric(unlist(split_str))
          subsample <- input$subsampleseqs
          prop = input$prop
          evaluate <- TRUE
          if(subsample == TRUE && is.na(prop) == TRUE){
            evaluate <- FALSE
          }else if(subsample == TRUE && (prop < 0 || prop > 1)){
            evaluate <- FALSE
          }
        }else if(input$Id008 == 'Gypsy moth (Lymantria dispar)'){
          N <- input$N_load_e
          Hstar <- input$Hstar_load_e
          x <- input$probs_load_e
          split_str <- strsplit(x, ",")
          probs <- as.numeric(unlist(split_str))
          subsample <- input$subsampleseqs
          prop = input$prop
          evaluate <- TRUE
          if(subsample == TRUE && is.na(prop) == TRUE){
            evaluate <- FALSE
          }else if(subsample == TRUE && (prop < 0 || prop > 1)){
            evaluate <- FALSE
          }
        }else if(input$Id008 == 'Scalloped hammerhead shark (Sphyrna lewini)'){
          N <- input$N_load_f
          Hstar <- input$Hstar_load_f
          x <- input$probs_load_f
          split_str <- strsplit(x, ",")
          probs <- as.numeric(unlist(split_str))
          subsample <- input$subsampleseqs
          prop = input$prop
          evaluate <- TRUE
          if(subsample == TRUE && is.na(prop) == TRUE){
            evaluate <- FALSE
          }else if(subsample == TRUE && (prop < 0 || prop > 1)){
            evaluate <- FALSE
          }
        }
        
        result <- metaRender(renderPrint,{
          validate(
            need(N >= Hstar,'N must be greater than or equal to Hstar'),
            need(N > 1,'N must be greater than 1'),
            need(Hstar > 1,'H* must be greater than 1'),
            need(isTRUE(all.equal(1, sum(probs), tolerance = .Machine$double.eps^0.25)),'probs must sum to 1'),
            need(length(probs) == Hstar,'probs must have Hstar elements'),
            need((perms > 1),'perms must be greater than 1'),
            need((p > 0) && (p <= 1),'p must be greater than 0 and less than or equal to 1'),
            need((conf.level > 0) && (conf.level < 1),'conf.level must be between 0 and 1.')
          )
          HACSObj <- HACHypothetical(N = N, Hstar = Hstar, probs = probs, perms = perms, p = p, 
                                     conf.level = conf.level,
                                     subsample = subsample, prop = prop,
                                     progress = progress, num.iters = num.iters, filename = NULL)
          values[["log"]] <- capture.output(data <- HAC.simrep(HACSObj))
        })
        
        output$text <- renderPrint({
          if(global$refresh) {
            return()
          }
          x <- values[["log"]]
          toBeReturned <- str_replace_all(x, '\\s+' , " ")
          return(print(noquote(toBeReturned)))
        })
        
        output$pdfview <- renderUI({
          if(global$refresh) {
            return()
          }
          path <- "www/Rplots.pdf"
          pdf(file=path,width=12, height=5,onefile=T,title = "HACSim Graphics Output",paper = "a4r")  
          result()
          dev.off()
          my_test <- tags$iframe(style="height:800px; width:100%; background-color: white;", src="Rplots.pdf")
          return({my_test})
        })
        
      }else{ # Real Species
        values <- reactiveValues()
        subsample <- input$subsampleseqs
        prop = input$prop
        evaluate <- TRUE
        if(subsample == TRUE && is.na(prop) == TRUE){
          evaluate <- FALSE
        }else if(subsample == TRUE && (prop < 0 || prop > 1)){
          evaluate <- FALSE
        }
        
        result <- metaRender(renderPrint,{
          validate(
            need((perms > 1),'perms must be greater than 1'),
            need((p > 0) && (p <= 1),'p must be greater than 0 and less than or equal to 1'),
            need((conf.level > 0) && (conf.level < 1),'conf.level must be between 0 and 1.'),
            need(evaluate == TRUE,'Proportion of DNA sequences to subsample is either missing, non-numeric, less than zero or greater than one.
               User must fill in positive numeric value for subsampling between 0 and 1.')
          )
          # creating a HACSObj object by running HACReal()
          HACSObj <- HACReal(perms = perms, p = p ,conf.level = conf.level,
                             subsample = subsample, prop = prop, progress = progress,
                             num.iters = num.iters, 
                             filename = NULL)
          values[["log"]] <- capture.output(data <- HAC.simrep(HACSObj))
          
        })
        output$text <- renderPrint({
          if(global$refresh) {
            return()
          }
          x <- values[["log"]]
          toBeReturned <- str_replace_all(x, '\\s+' , " ")
          return(print(noquote(toBeReturned)))
        })
        
        output$pdfview <- renderUI({
          if(global$refresh) {
            return()
          }
          path <- "www/Rplots.pdf"
          pdf(file=path,width=12, height=5,onefile=T,title = "HACSim Graphics Output",paper = "a4r")  
          result()
          dev.off()
          my_test <- tags$iframe(style="height:800px; width:100%; background-color: white;", src="Rplots.pdf")
          return({my_test})
        })
      }
      
      
    }else{ # Hypothetical
      values <- reactiveValues()
      N <- input$N
      Hstar <- input$Hstar
      x <- input$probs
      split_str <- strsplit(x, ",")
      probs <- as.numeric(unlist(split_str))
      subsample <- input$subsampleseqs_2
      prop <- input$prop_2
      evaluate <- TRUE
      if(subsample == TRUE && is.na(prop) == TRUE){
        evaluate <- FALSE
      }else if(subsample == TRUE && (prop < 0 || prop > 1)){
        evaluate <- FALSE
      }
      
      result <- metaRender(renderPrint,{
        validate(
          need(N >= Hstar,'N must be greater than or equal to Hstar'),
          need(N > 1,'N must be greater than 1'),
          need(Hstar > 1,'H* must be greater than 1'),
          need(isTRUE(all.equal(1, sum(probs), tolerance = .Machine$double.eps^0.25)),'probs must sum to 1'),
          need(length(probs) == Hstar,'probs must have Hstar elements'),
          need((perms > 1),'perms must be greater than 1'),
          need((p > 0) && (p <= 1),'p must be greater than 0 and less than or equal to 1'),
          need((conf.level > 0) && (conf.level < 1),'conf.level must be between 0 and 1.'),
          need(evaluate == TRUE,'Proportion of DNA sequences to subsample is either missing, non-numeric, less than zero or greater than one.
               User must fill in positive numeric value for subsampling between 0 and 1.')
        )
        HACSObj <- HACHypothetical(N = N,Hstar = Hstar,probs = probs,perms = perms, p = p, 
                                   conf.level = conf.level,
                                   subsample = subsample, prop = prop,
                                   progress = progress, num.iters = num.iters, filename = NULL)
        values[["log"]] <- capture.output(data <- HAC.simrep(HACSObj))
        
      })
      output$text <- renderPrint({
        if(global$refresh) {
          return()
        }
        x <- values[["log"]]
        toBeReturned <- str_replace_all(x, '\\s+' , " ")
        return(print(noquote(toBeReturned)))
      })
      
      output$pdfview <- renderUI({
        if(global$refresh) {
          return()
        }
        path <- "www/Rplots.pdf"
        pdf(file=path,width=12, height=5,onefile=T,title = "HACSim Graphics Output",paper = "a4r")  
        result()
        dev.off()
        my_test <- tags$iframe(style="height:800px; width:100%; background-color: white;", src="Rplots.pdf")
        return({my_test})
      })
    }
  })
  observeEvent(input$reset, {
    reset("perms")
  })
  observeEvent(input$reset, {
    reset("p")
  })
  observeEvent(input$reset, {
    reset("conf.level")
  })
  observeEvent(input$reset, {
    reset("num.iters")
  })
  observeEvent(input$reset, {
    reset("switch")
  })
  observeEvent(input$reset, {
    reset("fastafile")
  })
  observeEvent(input$reset, {
    reset("Id015")
  })
  observeEvent(input$reset, {
    reset("N")
  })
  observeEvent(input$reset, {
    reset("Hstar")
  })
  observeEvent(input$reset, {
    reset("probs")
  })
  observeEvent(input$reset, {
    reset("subsampleseqs")
  })
  observeEvent(input$reset, {
    reset("prop")
  })
  observeEvent(input$reset, {
    reset("subsampleseqs_2")
  })
  observeEvent(input$reset, {
    reset("prop_2")
  })

  global <- reactiveValues(refresh = FALSE)
  
  observeEvent(input$refresh, {
    if(input$refresh) isolate(global$refresh <- TRUE)
  })
  
  observeEvent(input$run, {
    if(input$run) isolate(global$refresh <- FALSE)
  })
  
  
}
