install.packages("ggplot2")
install.packages("palmerpenguins")
library(ggplot2)
library(palmerpenguins)
data(penguins)
View(penguins)

# mapping length and mass
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g))

# distinguishing species with color
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species))

# distinguishing species with shape
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, shape=species))

# distinguishing species with size
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, size=species))

# distinguishing species with color and shape
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species, shape=species))

# distinguishing species with opacity
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, alpha=species))

# all points purple, color goes outside of the parenthesis in quotes
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g), color="purple")

# mapping length and mass in line
ggplot(data=penguins) + 
  geom_smooth(mapping = aes(x=flipper_length_mm, y=body_mass_g))

# showing relationship between the points and trend line
ggplot(data=penguins) + 
  geom_smooth(mapping = aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g))  

# multiple lines showing trend per species
ggplot(data=penguins) + 
  geom_smooth(mapping = aes(x=flipper_length_mm, y=body_mass_g, linetype=species))

# scatterplot with noise
ggplot(data=penguins) + 
  geom_jitter(mapping = aes(x=flipper_length_mm, y=body_mass_g))

# bar chart, y automatically counts rows
ggplot(data=diamonds) + 
  geom_bar(mapping = aes(x=cut))

# add color to cut
ggplot(data=diamonds) + 
  geom_bar(mapping = aes(x=cut, fill=cut))

# add color to clarity instead to get stacked bar chart
ggplot(data=diamonds) + 
  geom_bar(mapping = aes(x=cut, fill=clarity))

# facets for subsets
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g)) +
  facet_wrap(~species)

# with color
ggplot(data=penguins, aes(x=flipper_length_mm, y=body_mass_g)) +
  geom_point(aes(color=species))+
  facet_wrap(~species)

# facet on diamond data set
ggplot(data=diamonds) + 
  geom_bar(mapping = aes(x=color, fill=cut))+
  facet_wrap(~cut)

# facet grid will split the plot vertically
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  facet_grid(sex~species)

# facet grid with species only
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  facet_grid(~species)

# annotations - title
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length")

# annotations - title and subtitle
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length", subtitle="Sample of Three Penguin Species")

# annotations - title, subtitle, and caption
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length", subtitle="Sample of Three Penguin Species", 
       caption="Data collected by Dr. Kristen Gorman")

# annotations - title, subtitle, caption, and text label
ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length", subtitle="Sample of Three Penguin Species", 
       caption="Data collected by Dr. Kristen Gorman")+
  annotate("text", x=220,y=3500,label="The Gentoos are the largest")

# assign long code to variable
p <- ggplot(data=penguins) + 
  geom_point(mapping = aes(x=flipper_length_mm, y=body_mass_g, color=species)) +
  labs(title="Palmer Penguins: Body Mass vs. Flipper Length", subtitle="Sample of Three Penguin Species", 
       caption="Data collected by Dr. Kristen Gorman")

# call p variable and add to it
p+annotate("text", x=220,y=3500,label="The Gentoos are the largest", color="purple", fontface="bold", size=4.5, angle=40)

# saving plots
ggsave("Three Penguin Species.png")
