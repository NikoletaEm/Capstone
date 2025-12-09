
library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(scales)


combined_nta <- readRDS("combined_nta.rds")
combined_neighborhood <- readRDS("combined_neighborhood.rds")
schools_mapped <- readRDS("schools_mapped.rds")

forecast_year <- 2026


# UI

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
        )
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
        actionButton("run_quiz", "🔍 Show My NTA Matches", class = "btn-primary"),
        actionButton("reset_quiz", "🧹 Reset Quiz", class = "btn-danger")
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


# SERVER

server <- function(input, output, session) {
  
  forecast_year <- 2027
  cleared <- reactiveVal(FALSE)
  
  # QUIZ FILTER
  quiz_filtered <- eventReactive(input$run_quiz, {
    
    cleared(FALSE)
    
    df <- combined_nta %>% filter(year == forecast_year)
    
    # Budget
    if (input$budget == "low")  df <- df %>% filter(mean_price < 650000)
    if (input$budget == "mid")  df <- df %>% filter(mean_price >= 650000 & mean_price <= 835000)
    if (input$budget == "high") df <- df %>% filter(mean_price > 835000)
    
    # Schools
    if ("top_school" %in% colnames(df)) {
      if (input$schools == "yes") df <- df %>% filter(top_school == TRUE)
      if (input$schools == "no")  df <- df %>% filter(top_school == FALSE)
    }
    
    # House Age
    if ("avg_house_age" %in% colnames(df)) {
      if (input$house_age_pref == "new") df <- df %>% filter(avg_house_age < 55)
      if (input$house_age_pref == "old") df <- df %>% filter(avg_house_age >= 55)
    }
    
    # Location
    if (input$location == "nj") df <- df %>% filter(near_nj == TRUE)
    if (input$location == "bk") df <- df %>% filter(near_brooklyn == TRUE)
    
    # Train
    if (input$train == "yes") df <- df %>% filter(train_access == TRUE)
    if (input$train == "no")  df <- df %>% filter(train_access == FALSE)
    
    df
  })
  
  # RESET LOGIC
  observeEvent(input$reset_quiz, {
    
    updateRadioButtons(session, "budget", selected = character(0))
    updateRadioButtons(session, "schools", selected = character(0))
    updateRadioButtons(session, "house_age_pref", selected = character(0))
    updateRadioButtons(session, "location", selected = character(0))
    updateRadioButtons(session, "train", selected = character(0))
    
    proxy <- dataTableProxy("quiz_results")
    selectRows(proxy, NULL)
    
    cleared(TRUE)
  })
  
  # OUTPUT TABLE
  output$quiz_results <- renderDT({
    
    if (cleared()) {
      return(datatable(
        data.frame(Message = "🔄 Quiz reset. Choose new preferences."),
        options = list(dom = "t")
      ))
    }
    
    df <- quiz_filtered()
    
    if (nrow(df) == 0) {
      return(datatable(
        data.frame(Message = "❌ No NTAs matched your preferences."),
        options = list(dom = "t")
      ))
    }
    
    df %>%
      mutate(`Forecasted Avg Price` = dollar(round(mean_price))) %>%
      select(NTA = nta_name, `Forecasted Avg Price`) %>%
      datatable(selection = "single", options = list(pageLength = 10))
  })
  
  # SELECTED NTA
  selected_nta <- reactive({
    s <- input$quiz_results_rows_selected
    req(s)
    quiz_filtered()$nta_name[s]
  })
  
  # CLEARABLE OUTPUTS
  output$nta_detail_title <- renderText({
    if (cleared()) return("")
    req(selected_nta())
    paste("📈 Price History for:", selected_nta())
  })
  
  output$nta_detail_trend <- renderPlotly({
    if (cleared()) return(NULL)
    req(selected_nta())
    
    df <- combined_nta %>% filter(nta_name == selected_nta())
    
    plot_ly(df, x = ~year, y = ~mean_price,
            type = "scatter", mode = "lines+markers")
  })
  
  output$nta_detail_table <- renderDT({
    if (cleared()) return(NULL)
    req(selected_nta())
    
    combined_nta %>%
      filter(nta_name == selected_nta()) %>%
      arrange(year) %>%
      mutate(mean_price = dollar(round(mean_price))) %>%
      datatable(options = list(pageLength = 10))
  })
  
  # NEIGHBORHOOD TAB
  output$price_trend_plot <- renderPlotly({
    df <- combined_neighborhood %>%
      filter(neighborhood == input$neighborhood)
    
    plot_ly(df, x = ~year, y = ~mean_price,
            type = "scatter", mode = "markers")
  })
  
  output$price_table <- renderDT({
    combined_neighborhood %>%
      filter(neighborhood == input$neighborhood) %>%
      datatable(options = list(pageLength = 10))
  })
  
}

shinyApp(ui, server)