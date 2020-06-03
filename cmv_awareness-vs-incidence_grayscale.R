library(tidyverse)
library(cowplot)
library(ggtext)

# Get data from Doutre et al.

df <- tribble(
  ~condition, ~awareness, ~incidence,
  "Congenital Cytomegalovirus (CMV)", 6.7, 6000,
  "Congenital Toxoplasmosis", 8.53, 400,
  "Congenital Rubella Syndrome", 13.27, 3,
  "Beta Strep (Group B Strep)", 16.91, 380,
  "Parvovirus B19 (Fifth Disease)", 19.63, 1045,
  "Fetal Alcohol Syndrome", 61.04, 1200,
  "Spina Bifida", 64.54, 1500,
  "Sudden Infant Death Syndrome (SIDS)", 78.7, 1500,
  "Down Syndrome", 85.44, 6000,
  "Congenital HIV/AIDS", 86.33, 30
)

# Create chart

p <- df %>%
  ggplot(aes(x = reorder(condition, desc(awareness)), y = awareness)) +
  geom_col(fill = "gray") +
  geom_point(
    aes(x = condition, y = incidence / 70),
    size = 4,
    pch = 21,
    fill = "black"
  ) +
  scale_y_continuous(
    sec.axis = sec_axis(
      ~ . * 70, 
      name = "Number of Children Disabled by the Condition Each Year (Dots)",
      labels = scales::comma_format()
    )
  ) +
  coord_flip() +
  labs(
    x = "",
    y = "Percentage of Women Who Have Heard of the Condition (Bars)",
    title = "Awareness vs Incidence of Congenital Conditions",
    caption = "Based on US data from Doutré SM *et al.* (2016) Losing Ground: Awareness of Congenital Cytomegalovirus 
    in the United States. *Journal of Early Hearing Detection and Intervention* 1:39-48."
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", hjust = .5),
    plot.caption = element_textbox_simple(size = 6, margin = margin(10, 0, 0, 0)),
    axis.text = element_text(color = "black"),
    axis.title = element_text(size = 10),
    axis.title.x = element_text()
  ) +
  background_grid(major = "none")

# Save chart

ggsave2(
  "images/cmv_awareness-vs-incidence_grayscale.png", 
  plot = p, 
  width = 7, 
  height = 4
)
