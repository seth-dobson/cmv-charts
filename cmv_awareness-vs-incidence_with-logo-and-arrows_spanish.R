library(tidyverse)
library(cowplot)
library(ggtext)
library(magick)

# Get data from Doutre et al.
# (Muerte de cuna)

df <- tribble(
  ~condition, ~awareness, ~incidence,
  "Citamegalovirus congénito (CMV)", 6.7, 6000,
  "Toxoplasmosis congénita", 8.53, 400,
  "Síndrome de rubeola congénita", 13.27, 3,
  "Estreptococo del grupo B", 16.91, 380,
  "Quinta enfermedad (Parvovirus B19)", 19.63, 1045,
  "Síndrome alcohólico fetal", 61.04, 1200,
  "Espina bífida", 64.54, 1500,
  "Síndrome de muerte súbita del lactante (SMSL)", 78.7, 1500,
  "Síndrome de Down", 85.44, 6000,
  "VIH/SIDA perinatal", 86.33, 30
)

# Get National CMV logo

logo <- image_read("CMV-Full-Tagline-Logo_Transparent.png")

# Create chart

p <- df %>%
  ggplot(aes(x = reorder(condition, desc(awareness)), y = awareness)) +
  geom_col(fill = "#28C1DB") +
  geom_point(
    aes(x = condition, y = incidence / 70),
    size = 4,
    pch = 21,
    fill = "#FB791A"
  ) +
  scale_y_continuous(
    sec.axis = sec_axis(
      ~ . * 70, 
      name = "Numero de niños discapacitados por la condición cada año (puntos)",
      labels = scales::comma_format()
    )
  ) +
  coord_flip() +
  labs(
    x = "",
    y = "Porcentaje de mujeres que han oído hablar sobre la condición (barras)",
    title = "Conciencia vs. Incidencia de Condiciones Congénitas",
    caption = "Basado en datos de EE. UU. de Doutré SM *et al.* (2016) Losing Ground: Awareness of Congenital Cytomegalovirus 
    in the United States. *Journal of Early Hearing Detection and Intervention* 1:39-48. Grafico por Artful Analytics, 
    LLC (@_sethdobson). <br>Para mas información visite nationalcmv.org."
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", hjust = .5),
    plot.caption = element_textbox_simple(size = 6, margin = margin(10, 0, 0, 0)),
    axis.text = element_text(color = "black"),
    axis.title = element_text(size = 10),
    axis.title.x = element_text()
  ) +
  background_grid(major = "none") +
  annotate(
    geom = "text",
    label = "Numero de niños \ndiscapacitados por CMV",
    x = 7.8,
    y = 75,
    color = "#FB791A",
    size = 3
  ) +
  annotate(
    geom = "curve", 
    x = 8.5, 
    y = 75, 
    xend = 10, 
    yend = 84,
    curvature = -.3, 
    arrow = arrow(length = unit(2, "mm")),
    color = "#FB791A"
  ) +
  annotate(
    geom = "text",
    label = "% de mujeres que han oído \nhablar sobre CMV",
    x = 7.8,
    y = 30,
    color = "#28C1DB",
    size = 3
  ) +
  annotate(
    geom = "curve", 
    x = 8.5, 
    y = 30, 
    xend = 10, 
    yend = 7,
    curvature = .20, 
    arrow = arrow(length = unit(2, "mm")),
    color = "#28C1DB"
  )

# Combine chart with logo

combo <- ggdraw() +
  draw_plot(p) +
  draw_image(
    logo, 
    x = .075, 
    y = .1, 
    scale = .2, 
    hjust = .5, 
    vjust = .5
  )

# Save combination

ggsave2(
  "images/cmv_awareness-vs-incidence_with-logo-and-arrows_spanish.png", 
  plot = combo, 
  width = 7.7, 
  height = 4
)
