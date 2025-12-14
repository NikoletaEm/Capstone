library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(scales)


# ---------------------------
# DATA
# ---------------------------
combined_nta <- readRDS("combined_nta.rds")
combined_neighborhood <- readRDS("combined_neighborhood.rds")
schools_mapped <- readRDS("schools_mapped.rds")

forecast_year <- 2026

# ---------------------------
# UI
# ---------------------------
ui <- fluidPage(
  
  titlePanel("Staten Island Housing Price Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      
      radioButtons(
        "mode",
        "What would you like to do?",
        choices = c(
          "📝 Take the NTA Preference Quiz" = "quiz",
          "📊 View All NTAs (Forecasted Prices)" = "all"
        ),
        selected = "quiz"
      ),
      
      conditionalPanel(
        condition = "input.mode == 'quiz'",
        
        hr(),
        h4("💸 Budget (Forecasted)"),
        radioButtons("budget", NULL, choices = c(
          "Lower-Priced: Under $650K" = "low",
          "Mid-Priced: $650K – $835K" = "mid",
          "Upper-Priced: Over $835K" = "high",
          "I don't have a budget" = "none"
        )),
        
        hr(),
        h4("🥇 Interested in Top-Ranked Schools?"),
        radioButtons("schools", NULL, choices = c(
          "Yes" = "yes",
          "No" = "no",
          "I don't care" = "na"
        )),
        
        hr(),
        h4("🏠 Home Style Preference"),
        radioButtons("house_age_pref", NULL, choices = c(
          "More modern neighborhoods (mostly built after 1970)" = "new",
          "More historic neighborhoods (mostly built before 1970)" = "old",
          "I don't have a preference" = "na"
        )),
        
        hr(),
        h4("🌇 Preferred Location"),
        radioButtons("location", NULL, choices = c(
          "Across from New Jersey" = "nj",
          "Across from Brooklyn" = "bk",
          "I don't mind" = "na"
        )),
        
        hr(),
        h4("🚂 Train Access"),
        radioButtons("train", NULL, choices = c(
          "Yes" = "yes",
          "No" = "no",
          "I don't care" = "na"
        )),
        
        hr(),
        actionButton("run_quiz", "🔍 Show My NTA Matches", class = "btn-primary")
      ),
      
      hr(),
      selectInput(
        "neighborhood",
        "Select Neighborhood (Tab 2):",
        choices = sort(unique(combined_neighborhood$neighborhood))
      )
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(
          "NTA Finder",
          DTOutput("quiz_results"),
          hr(),
          h4(textOutput("nta_detail_title")),
          plotlyOutput("nta_detail_trend", height = "350px"),
          DTOutput("nta_detail_table")
        ),
        
        tabPanel(
          "🏘️ Neighborhood Price Trends",
          plotlyOutput("price_trend_plot", height = "400px"),
          DTOutput("price_table")
        )
      )
    )
  )
)

# ---------------------------
# SERVER
# ---------------------------
server <- function(input, output, session) {
  

  quiz_filtered <- eventReactive(input$run_quiz, {
    
    df <- combined_nta %>% filter(year == forecast_year)
    
    if (input$budget == "low")  df <- df %>% filter(mean_price < 650000)
    if (input$budget == "mid")  df <- df %>% filter(mean_price >= 650000 & mean_price <= 835000)
    if (input$budget == "high") df <- df %>% filter(mean_price > 835000)
    
    if ("top_school" %in% colnames(df)) {
      if (input$schools == "yes") df <- df %>% filter(top_school)
      if (input$schools == "no")  df <- df %>% filter(!top_school)
    }
    
    if ("avg_house_age" %in% colnames(df)) {
      if (input$house_age_pref == "new") df <- df %>% filter(avg_house_age < 55)
      if (input$house_age_pref == "old") df <- df %>% filter(avg_house_age >= 55)
    }
    
    if (input$location == "nj") df <- df %>% filter(near_nj)
    if (input$location == "bk") df <- df %>% filter(near_brooklyn)
    
    if (input$train == "yes") df <- df %>% filter(train_access)
    if (input$train == "no")  df <- df %>% filter(!train_access)
    
    df
  })
  
 
  nta_display_data <- reactive({
    
    if (input$mode == "all") {
      return(
        combined_nta %>% filter(year == forecast_year)
      )
    }
    
    req(input$run_quiz)
    quiz_filtered()
  })
  
  # ---------------------------
  # MAIN TABLE
  # ---------------------------
  output$quiz_results <- renderDT({
    
    df <- nta_display_data()
    
    if (nrow(df) == 0) {
      return(
        datatable(
          data.frame(Message = "❌ No NTAs matched your preferences."),
          options = list(dom = "t"),
          rownames = FALSE
        )
      )
    }
    
    df %>%
      mutate(`Forecasted Avg Price` = dollar(round(mean_price))) %>%
      select(NTA = nta_name, `Forecasted Avg Price`) %>%
      datatable(
        selection = "single",
        options = list(pageLength = 10),
        rownames = FALSE
      )
  })
  

  selected_nta <- reactive({
    s <- input$quiz_results_rows_selected
    req(length(s) == 1)
    nta_display_data()$nta_name[s]
  })
  
  # ---------------------------
  # DETAIL OUTPUTS
  # ---------------------------
  output$nta_detail_title <- renderText({
    req(selected_nta())
    paste("📈 Price History for:", selected_nta())
  })
  
  output$nta_detail_trend <- renderPlotly({
    req(selected_nta())
    
    df <- combined_nta %>% filter(nta_name == selected_nta())
    
    plot_ly(
      df,
      x = ~year,
      y = ~mean_price,
      type = "scatter",
      mode = "lines+markers"
    )
  })
  
  output$nta_detail_table <- renderDT({
    req(selected_nta())
    
    combined_nta %>%
      filter(nta_name == selected_nta()) %>%
      arrange(year) %>%
      mutate(mean_price = dollar(round(mean_price))) %>%
      datatable(options = list(pageLength = 10), rownames = FALSE)
  })
  
  # ---------------------------
  # NEIGHBORHOOD TAB
  # ---------------------------
  output$price_trend_plot <- renderPlotly({
    
    df <- combined_neighborhood %>%
      filter(neighborhood == input$neighborhood)
    
    plot_ly(
      df,
      x = ~year,
      y = ~mean_price,
      type = "scatter",
      mode = "markers"
    )
  })
  
  output$price_table <- renderDT({
    
    combined_neighborhood %>%
      filter(neighborhood == input$neighborhood) %>%
      datatable(options = list(pageLength = 10), rownames = FALSE)
  })
}

shinyApp(ui, server)
