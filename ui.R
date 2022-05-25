# This file defines the UI of the application
# client-side functionality

# UI is styled with CSS

# importing shiny library
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
# importing shiny widgets
library(shinyWidgets)

# importing shiny css loaders
library(shinycssloaders)

# importing HACSim library
library(HACSim)

# importing ggplot2
library(ggplot2)

# defining the logo for the home page
logo <- a(href = "", img(src = "HACSim.png", salt = "HACSim: Haplotype Accumulation Curve Simulator", height = "100px",width="300px"))

tags$body(
  tags$style(type="text/css", "body {padding-top: 66px;}"),
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    )
  ),
  # navigation bar to navigate through page
  useShinyjs(),
  navbarPage(
    position = "fixed-top",
    title = logo,
    selected = "Home",
    windowTitle = "HACSim: Haplotype Accumulation Curve Simulator",
    # App UI contents are chilling here!
    tagList(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
      )
    ),
    tabPanel(
      "Home",
      selected = TRUE,
      div(
        style = "position: fixed; left: 0; top: 0; z-index: -1;",
        img(src = "c.jpg", style = "min-width: 100vw; min-height: 100vh;")
      ),
        tags$blockquote(h1("HACSim helps researchers estimate required specimen sample sizes necessary for species genetic diversity assessment
      ",style="font-size:2.5vw; color:white;position:fixed;left:5%;top:30%;
                  right:20%")
      ),
      div(h3("Abstract",style="color:white;"),h1("Assessing levels of standing genetic variation within species requires a robust sampling
for the purpose of accurate specimen identification using molecular techniques such
as DNA barcoding; however, statistical estimators for what constitutes a robust sample
are currently lacking. Moreover, such estimates are needed because most species are
currently represented by only one or a few sequences in existing databases, which
can safely be assumed to be undersampled. Unfortunately, sample sizes of 5–10
specimens per species typically seen in DNA barcoding studies are often insufficient to
adequately capture within-species genetic diversity. Here, we introduce a novel iterative
extrapolation simulation algorithm of haplotype accumulation curves, called HACSim
(Haplotype Accumulation Curve Simulator) that can be employed to calculate likely
sample sizes needed to observe the full range of DNA barcode haplotype variation that
exists for a species. Using uniform haplotype and non-uniform haplotype frequency
distributions, the notion of sampling sufficiency (the sample size at which sampling
accuracy is maximized and above which no new sampling information is likely to be
gained) can be gleaned. HACSim can be employed in two primary ways to estimate
specimen sample sizes: (1) to simulate haplotype sampling in hypothetical species,
and (2) to simulate haplotype sampling in real species mined from public reference
sequence databases like the Barcode of Life Data Systems (BOLD) or GenBank for any
genomic marker of interest. While our algorithm is globally convergent, runtime is
heavily dependent on initial sample sizes and skewness of the corresponding haplotype
frequency distribution.",style="font-family: 'Times New Roman', Times, serif;font-size:1vw; color:white;"),
          style = "position:fixed;left:2%;bottom:5%;")
      ),
    tabPanel("Tutorial",
             includeHTML("tutorial.html"),
             div(
               style = "position: fixed; left: 0; top: 0; z-index: -1;",
               img(src = "about.jpg", style = "min-width: 100vw; min-height: 100vh;")
             )
             ),
    tabPanel("About",
             style="margin-top:40px;float:initial",
             div(
               style = "position: fixed; left: 0; top: 0; z-index: -1;",
               img(src = "about.jpg", style = "min-width: 100vw; min-height: 100vh;")
             ),
             tabsetPanel(type = "pills",tabPanel("About HACSim",
                                                 style = "padding-top:5px;",
                                                 tags$blockquote(h3("What is HACSim and how does it work?"),
                                                                 p("HACSim is a novel nonparametric stochastic (Monte Carlo) local search optimization algorithm written in R 
                        for the simulation of haplotype accumulation curves. It can be employed to determine likely required 
                        sample sizes for DNA barcoding, specifically pertaining to recovery of total haplotype variation that may 
                        exist for a given species."),
                                                                 p("Most DNA barcoding studies conducted to date suggest sampling between 5-10 individuals per 
                        species due to research costs. However, it has been shown that low sample sizes can greatly 
                        underestimate haplotype diversity for geograpically-widespread taxa. The present algorithm 
                        is in place to more accurately determine sample sizes that are needed to uncover all putative 
                        haplotypes that may exist for a given species. Implications of such an approach include 
                        accelerating the construction and growth of DNA barcode reference libraries for species of 
                        interest within the Barcode of Life Data Systems", (tags$a(href = "http://www.boldsystems.org", "(BOLD)")), 
                                                                   "or similar database such as", (tags$a(href = "https://www.ncbi.nlm.nih.gov/genbank/", "GenBank."))),
                                                                 p("Within the simulation algorithm, species haplotypes are treated as distinct character labels 
                        (1, 2, ...), where 1 denotes the most frequent haplotype, 2 denotes the second-most frequent 
                        haplotype, and so forth. The algorithm then randomly samples species haplotype labels in an 
                        iterative fashion, until all unique haplotypes have been observed. The idea is that levels of 
                        species haplotypic variation that are currently catalogued in BOLD can serve as proxies for 
                        total haplotype diversity that may exist for a given species."),
                                                                 p("Molecular loci besides DNA barcode genes (5'-COI, rbcL/matK, ITS regions) can be used with HACSim 
                        (",em("e.g.,", .noWS = c("before")),"cytb)."),style="font-size:120%; color:black;
                  "),
                                                 tags$blockquote(h3("App version"),
                                                                 p("The HACSim R Shiny web app is currently running on version 1.05 of the HACSim R package."))),
                         tabPanel("More Information",style = "padding-top:5px;",tags$blockquote(h3("More Information"), 
                                                                                                p("Are you interested in doing even more with HACSim? Consider downloading the R package! See the HACSim", 
                                                                                                  tags$a(href = "https://cran.r-project.org/web/packages/HACSim/index.html", "CRAN",target = "_blank"),
                                                                                                  "page for more details. You can also check out the development version of the HACSim R package on", 
                                                                                                  tags$a(href = "https://github.com/jphill01/HACSim.R", "GitHub.", target = "_blank")),style="font-size:120%; color:black;
                  ")),
                         tabPanel(
                           "Authors",style = "padding-top:5px;",
                           tags$blockquote(h3("Jarrett D. Phillips"),
                                           p("Email: phillipsjarrett1@gmail.com")),
                           tags$blockquote(h3("Navdeep Singh"),
                                           p("Email: navuonweb@gmail.com"))
                         ),
                         tabPanel("Citations",style = "padding-top:5px;",
                                  tags$blockquote(h3("Citations"),
                                                  br(),
                                                  p("If you intend to use the HACSim R Shiny web app in your research, please cite the HACSim publication below. A publication for the app is currently in preparation for submission to", em("Bioinformatics"), "as an Application Note."),
                                                  tags$ul(
                                                    tags$li(p("Chang, W.,", "Cheng, J., Allaire, J.J., Sievert, C., Schloerke, B., Xie, Y., Allen, J., McPherson, J., Dipert, A. and Borges, B. (2021). shiny: Web Application Framework for R. R package version 1.6.0.
                                                        https://CRAN.R-project.org/package=shiny")),
                                                    tags$li(p(strong("Phillips, J.D.", .noWS = c("after")),",", "French, S.H., Hanner, R.H. and  Gillis, D.J. (2020). HACSim: An 
                    R package to estimate intraspecific sample sizes for genetic diversity assessment 
                    using haplotype accumulation curves.",em("PeerJ Computer Science,"), strong("6", .noWS = c("after")),"(192): 1-37. DOI: 10.7717/peerj-cs.243."),href="Phillips et al. (2020).pdf", target = "_blank"),
                                                    tags$li(p(strong("Phillips, J.D.", .noWS = c("after")),",", "Gillis, D.J. and Hanner, R.H. (2019). Incomplete estimates of genetic diversity within species: Implications for DNA barcoding. ",em("Ecology and Evolution,"), strong("9", .noWS = c("after")),"(5): 2996-3010. DOI: 10.1002/ece3.4757."),href="Phillips et al. (2019).pdf", target = "_blank"),
                                                    tags$li(p(strong("Phillips, J.D.", .noWS = c("after")),",", "Gwiazdowski, R.A., Ashlock, D. and Hanner, R. (2015). An exploration of sufficient sampling effort to describe intraspecific DNA barcode
                                                        haplotype diversity: examples from the ray-finned fishes (Chordata: Actinopterygii).",em("DNA Barcodes,"), strong("3", .noWS = c("after")),": 66-73. DOI: 10.1515/dna-2015-0008."),href="Phillips et al. (2015).pdf", target = "_blank"),
                                                    tags$li(p("Ratnasingham, S. and Hebert, P.D.N. (2007). BOLD: The Barcode of Life Data System (www.barcodinglife.org).",em("Molecular Ecology Notes"), strong("7", .noWS = c("after")),"(3): 355-364. URL: https://v4.boldsystems.org."))
                                                  ),style="font-size:120%; color:black;"))),style="position:fixed;top:15%"
                                            
                                                      
    ),
    tabPanel(
      style = "margin-left:0px;",
      div(
        style = "margin-top:-7px;",
        actionBttn(
          inputId = "run_simulation",
          size = "sm",
          label ="Run Simulation",
          color = "warning",
          style = "material-flat",
          icon = icon("rocket"),
          block = TRUE
        )
      ),
      titlePanel(h1("",style = "padding-top:10px;")),
      div(
        style = "position: fixed; left: 0; top: 0; z-index: -1;",
        img(src = "run_sim.jpg", style = "min-width: 100vw; min-height: 100vh;")
      ),
      tabsetPanel(
        type = "pills",
        tabPanel("Main interface",
                 style = "padding-top: 5px; margin-left:-13px;",
                 selected = TRUE,
                 div(),
                 sidebarPanel(
                   width = 12,
                   numericInput(inputId = "perms",
                                label = "Number of permutations (perms)",
                                value = 10000,
                                min = 2,
                                step = 1),
                   
                   numericInput(inputId = "p",
                                label = "Proportion of haplotypes to recover (p)",
                                value = 0.95,
                                min = 0,
                                max = 1,
                                step = 0.01), 
                   
                   numericInput(inputId = "conf.level",
                                label = "Desired confidence level (conf.level)",
                                value = 0.95,
                                min = 0.01,
                                max = 0.99,
                                step = 0.01),
                   
                   numericInput(inputId = "num.iters",
                                label = "Number of iterations to run (num.iters)",
                                value = NA,
                                min = 1,
                                max = 1),
                   
                   switchInput(
                     label = "Progress",
                     inputId = "progress_bar",
                     onLabel = "True",
                     offLabel = "False",
                     value = TRUE,
                     onStatus = "success", 
                     offStatus = "danger",
                     labelWidth = "80px",
                     disabled = TRUE
                   ),
                   br(),
                   actionBttn(
                     inputId = "reset",
                     label = "Reset",
                     color = "success",
                     style = "jelly",
                     size ="sm",
                     block = FALSE
                   ),
                   
                 ) # end side bar Panel
                 
        ),
        tabPanel("Sub interface",
                 style = "padding-top: 5px; margin-left:-13px;",
                 sidebarPanel(
                   width = 12,
                   h3("Simulation type"),
                   switchInput(
                     inputId = "switch",
                     onLabel = "Real",
                     offLabel = "Hypothetical",
                     value = TRUE,
                     onStatus = "success", 
                     offStatus = "danger"
                   ),
                   conditionalPanel(condition = "input.switch == 1",
                                    h3("Preloaded examples"),
                                    switchInput(
                                      inputId = "Id015",
                                      onLabel = "Show",
                                      offLabel = "Hide",
                                      value = FALSE,
                                      onStatus = "success", 
                                      offStatus = "danger"
                                    ),
                                    conditionalPanel(condition = "input.Id015 == 0",
                                                     checkboxInput(inputId = "subsampleseqs", 
                                                                   label = "Subsample DNA sequences",
                                                                   value = FALSE),
                                                     helpText(strong("Note", .noWS = c("after")),": Inputted DNA sequences should not contain missing and/or ambiguous 
	                                       nucleotides, which may lead to overestimation of the number of 
	                                       observed unique haplotypes. Consider excluding sequences or alignment 
	                                       sites containing these data. If missing and/or ambiguous bases occur 
	                                       at the ends of sequences, further alignment trimming is an option.")
                                    ),
                                    conditionalPanel(condition = "input.Id015 == 1",
                                                     pickerInput(
                                                       inputId = "Id008",
                                                       width = '50%',
                                                       choices = c("Pea aphid (Acyrthosiphon pisum)","Lake whitefish (Coregonus clupeaformis)",  
                                                                   "Common mosquito (Culex pipiens)", "Deer tick (Ixodes scapularis)","Gypsy moth (Lymantria dispar)","Scalloped hammerhead shark (Sphyrna lewini)"),
                                                       multiple = FALSE,
                                                       selected = "Pea aphid (Acyrthosiphon pisum)", 
                                                     ),
                                                     conditionalPanel(condition = "input.Id008 == 'Lake whitefish (Coregonus clupeaformis)'",
                                                                      tags$a(
                                                                        tags$i(" Coregonus clupeaformis_aligned.fas",class="fas fa-file-download"),href = "Coregonus clupeaformis_aligned.fas",download = "Coregonus clupeaformis_aligned.fas"),
                                                                      br(),
                                                                      tags$progress("100%",value = "100",max="100"),
                                                                      tags$text("Upload complete ✓"),
                                                                      numericInput(inputId = "N_load_a",
                                                                                   label = "Number of observed specimens (N)",
                                                                                   value = 235,
                                                                                   min = 235,
                                                                                   max = 235),
                                                                      
                                                                      numericInput(inputId = "Hstar_load_a",
                                                                                   label = "Number of observed haplotypes (Hstar)",
                                                                                   value = 15,
                                                                                   min = 15,
                                                                                   max = 15),
                                                                      
                                                                      textInput(inputId = "probs_load_a",
                                                                                label = "Haplotype frequency distribution (probs)",
                                                                                value = "0.914893617,0.012765957,0.012765957,0.008510638,0.008510638,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319,0.004255319")
                                                     ),
                                                     conditionalPanel(condition = "input.Id008 == 'Pea aphid (Acyrthosiphon pisum)'",
                                                                      tags$a(
                                                                        tags$i(" Acyrthosiphon pisum_aligned.fas",class="fas fa-file-download"),href = "Acyrthosiphon pisum_aligned.fas",download = "Acyrthosiphon pisum_aligned.fas"),
                                                                      br(),
                                                                      tags$progress("100%",value = "100",max="100"),
                                                                      tags$text("Upload complete ✓"),
                                                                      numericInput(inputId = "N_load_b",
                                                                                   label = "Number of observed specimens (N)",
                                                                                   value = 356,
                                                                                   min = 356,
                                                                                   max = 356),
                                                                      
                                                                      numericInput(inputId = "Hstar_load_b",
                                                                                   label = "Number of observed haplotypes (Hstar)",
                                                                                   value = 12,
                                                                                   min = 12,
                                                                                   max = 12),
                                                                      
                                                                      textInput(inputId = "probs_load_b",
                                                                                label = "Haplotype frequency distribution (probs)",
                                                                                value = "0.966292135,0.005617978,0.002808989,0.002808989,0.002808989,0.002808989, 0.002808989,0.002808989,0.002808989,0.002808989,0.002808989,0.002808989")
                                                     ),
                                                     conditionalPanel(condition = "input.Id008 == 'Common mosquito (Culex pipiens)'",
                                                                      tags$a(
                                                                        tags$i(" Culex pipens_aligned.fas",class="fas fa-file-download"),href = "Culex pipens_aligned.fas",download = "Culex pipens_aligned.fas"),
                                                                      br(),
                                                                      tags$progress("100%",value = "100",max="100"),
                                                                      tags$text("Upload complete ✓"),
                                                                      numericInput(inputId = "N_load_c",
                                                                                   label = "Number of observed specimens (N)",
                                                                                   value = 217,
                                                                                   min = 217,
                                                                                   max = 217),
                                                                      
                                                                      numericInput(inputId = "Hstar_load_c",
                                                                                   label = "Number of observed haplotypes (Hstar)",
                                                                                   value = 25,
                                                                                   min = 25,
                                                                                   max = 25),
                                                                      
                                                                      textInput(inputId = "probs_load_c",
                                                                                label = "Haplotype frequency distribution (probs)",
                                                                                value = "0.843317972,0.032258065,0.009216590,0.009216590,0.009216590,0.009216590,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295,0.004608295")
                                                     ),
                                                     conditionalPanel(condition = "input.Id008 == 'Deer tick (Ixodes scapularis)'",
                                                                      tags$a(
                                                                        tags$i(" Ixodes scapularis_aligned.fas",class="fas fa-file-download"),href = "Ixodes scapularis_aligned.fas",download = "Ixodes scapularis_aligned.fas"),
                                                                      br(),
                                                                      tags$progress("100%",value = "100",max="100"),
                                                                      tags$text("Upload complete ✓"),
                                                                      numericInput(inputId = "N_load_d",
                                                                                   label = "Number of observed specimens (N)",
                                                                                   value = 349,
                                                                                   min = 349,
                                                                                   max = 349),
                                                                      
                                                                      numericInput(inputId = "Hstar_load_d",
                                                                                   label = "Number of observed haplotypes (Hstar)",
                                                                                   value = 83,
                                                                                   min = 83,
                                                                                   max = 83),
                                                                      
                                                                      textInput(inputId = "probs_load_d",
                                                                                label = "Haplotype frequency distribution (probs)",
                                                                                value = "0.131805158,0.083094556,0.071633238,0.063037249,0.057306590,0.037249284,0.034383954,0.034383954,0.025787966,0.022922636,0.020057307,0.020057307,0.020057307,0.017191977,0.017191977,0.014326648,0.014326648,0.014326648,0.011461318,0.011461318,0.011461318,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.008595989,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.005730659,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330,0.002865330")
                                                     ),
                                                     conditionalPanel(condition = "input.Id008 == 'Gypsy moth (Lymantria dispar)'",
                                                                      tags$a(
                                                                        tags$i(" Lymantria dispar_aligned.fas",class="fas fa-file-download"),href = "Lymantria dispar_aligned.fas",download = "Lymantria dispar_aligned.fas"),
                                                                      br(),
                                                                      tags$progress("100%",value = "100",max="100"),
                                                                      tags$text("Upload complete ✓"),
                                                                      numericInput(inputId = "N_load_e",
                                                                                   label = "Number of observed specimens (N)",
                                                                                   value = 365,
                                                                                   min = 365,
                                                                                   max = 365),
                                                                      
                                                                      numericInput(inputId = "Hstar_load_e",
                                                                                   label = "Number of observed haplotypes (Hstar)",
                                                                                   value = 58,
                                                                                   min = 58,
                                                                                   max = 58),
                                                                      
                                                                      textInput(inputId = "probs_load_e",
                                                                                label = "Haplotype frequency distribution (probs)",
                                                                                value = "0.232876712,0.208219178,0.120547945,0.106849315,0.035616438,0.024657534,0.024657534,0.019178082,0.013698630,0.013698630,0.013698630,0.010958904,0.010958904,0.010958904,0.008219178,0.008219178,0.008219178,0.005479452,0.005479452,0.005479452,0.005479452,0.005479452,0.005479452,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726,0.002739726")
                                                     ),
                                                     conditionalPanel(condition = "input.Id008 == 'Scalloped hammerhead shark (Sphyrna lewini)'",
                                                                      tags$a(
                                                                        tags$i(" Sphyrna lewini_aligned.fas",class="fas fa-file-download"),href = "Sphyrna lewini_aligned.fas",download = "Sphyrna lewini_aligned.fas"),
                                                                      br(),
                                                                      tags$progress("100%",value = "100",max="100"),
                                                                      tags$text("Upload complete ✓"),
                                                                      numericInput(inputId = "N_load_f",
                                                                                   label = "Number of observed specimens (N)",
                                                                                   value = 171,
                                                                                   min = 171,
                                                                                   max = 171),
                                                                      
                                                                      numericInput(inputId = "Hstar_load_f",
                                                                                   label = "Number of observed haplotypes (Hstar)",
                                                                                   value = 12,
                                                                                   min = 12,
                                                                                   max = 12),
                                                                      
                                                                      textInput(inputId = "probs_load_f",
                                                                                label = "Haplotype frequency distribution (probs)",
                                                                                value = "0.409356725,0.304093567,0.163742690,0.035087719,0.029239766,0.023391813,0.005847953,0.005847953,0.005847953,0.005847953,0.005847953,0.005847953")
                                                     )),
                                    conditionalPanel(condition = "input.subsampleseqs == 1",
                                                     numericInput(inputId = "prop",
                                                                  label = "Proportion of DNA sequences to subsample (prop.seqs)",
                                                                  value = 0.20,
                                                                  min = 0,
                                                                  max = 1,
                                                                  step = 0.01),
                                                     
                                    )
                                    
                   ),
                   conditionalPanel(condition = "input.switch != 1",
                                    numericInput(inputId = "N",
                                                 label = "Number of sampled specimens/DNA sequences (N)",
                                                 value = 100,
                                                 min = 2),
                                    
                                    numericInput(inputId = "Hstar",
                                                 label = "Number of observed species' haplotypes (Hstar)",
                                                 value = 5,
                                                 min = 1),
                                    
                                    textInput(inputId = "probs",
                                              label = "Observed haplotype frequency distribution (probs)",
                                              value = "0.20, 0.20, 0.20, 0.20, 0.20")
                                    ,
                                    
                                    checkboxInput(inputId = "subsampleseqs_2", 
                                                  label = "Subsample haplotype labels",
                                                  value = FALSE),
                                    
                                    conditionalPanel(condition = "input.subsampleseqs_2 == 1",
                                                     numericInput(inputId = "prop_2",
                                                                  label = "Proportion of haplotype labels to subsample (prop.haps)",
                                                                  value = "0.20",
                                                                  min = 0,
                                                                  max = 1,
                                                                  step = 0.01),
                                                     
                                    )
                   ),
                   br(),
                   actionBttn(
                     inputId = "run",
                     label ="Run",
                     color = "success",
                     style = "jelly",
                     size ="sm",
                     block = FALSE
                   ),
                   actionBttn(
                     inputId = "refresh",
                     label = "Refresh",
                     color = "success",
                     style = "jelly",
                     size ="sm",
                     block = FALSE
                   ),
                  
                   helpText(strong("Disclaimer", .noWS = c("after")),": Simulation may take time to run depending on the size of the inputted dataset and parameters."))
        ),
        
        sidebarPanel(
          style = "padding-top: 5px; margin-left:-13px;",
          width = 12,
          wellPanel(
            style = "background:white;",
            h3("Result Panel"),
            verbatimTextOutput("text"),
            withSpinner(
              image = "giphy.gif", image.width = 200, image.height = 200,
              uiOutput('pdfview')
            )
          )
        )
      )
    )
  )
)
