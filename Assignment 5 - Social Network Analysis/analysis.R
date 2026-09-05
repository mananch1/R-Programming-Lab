## Basic operations on graphs ##

# Social Network Analysis
library(igraph)
g <- graph(c(1,2,2,1,2,3,3,4,2,5),
           directed = F,
           n = 7)
plot(g,
     vertex.color = "green",
     vertex.size = 40,
     edge.color = "yellow")

print(g[])

friends <- graph(c("Mark","Adam","Adam","Bob","Mark",
        "Clavicular","Clavicular","IShowSpeed","IShowSpeed","Adam"),
      directed = T)

plot(friends,
     vertex.color = "green",
     vertex.size = 50,
     
     edge.color = "blue"
     )


# Network Measures

degree(friends,mode="in")

diameter(friends)

edge_density(friends,loops=F)

ecount(friends)/(vcount(friends)*(vcount(friends)-1))

reciprocity(friends)

closeness(friends, mode = "all",weights = NA)

betweenness(friends, directed = T)


## Experiment Start ##

# Reading the data
data <- read.csv("D:\\DOCS\\VIT\ Ebooks\\Fourth\ Year\\Sem\ 7\\R\\Lab\\Assignment\ 5\ -\ Social\ Network\ Analysis\\networkdata.csv")


df <- data.frame(data$first,data$second)

#Creating a network

net <- graph.data.frame(df,directed = T)

E(net)
V(net)

V(net)$label <- V(net)$name
V(net)$degree <- degree(net)

V(net)$label
V(net)$degree

# Histogram of node degree

hist(V(net)$degree,
     col = "green",
     main = "Histogram of Node Degree",
     ylab = "Frequency",
     xlab = "Degree of Vertices")


#Network diagram

set.seed(222)

plot(net,
     vertex.color = "green",
     vertex.size = 12,
     
     edge.arrow.size = .1,
     vertex.label.cex = .8)

# Highlighting degrees & layouts

plot(net,
     vertex.color = rainbow(52),
     vertex.size = V(net)$degree*.4,
     edge.arrow.size = 0.1,
     layout = layout_with_fr(net)
     )


plot(net,
     vertex.color = rainbow(52),
     vertex.size = V(net)$degree*.4,
     edge.arrow.size = 0.1,
     layout = layout_with_kk(net)
)

# Hubs and Authorities
hs <- hub_score(net)$vector
as <- authority.score(net)$vector

par(mfrow=c(1,2))
set.seed(123)
plot(net,
     vertex.size=hs*30,
     main = 'Hubs',
     vertex.color = rainbow(52),
     edge.arrow.size=0.1,
     Layout = layout_with_kk(net))

plot(net,
     vertex.size=as*30,
     main = 'Authorities',
     vertex.color = rainbow(52),
     edge.arrow.size=0.1,
     Layout = layout_with_kk(net))


#Community Detection

par(mfrow=c(1,1))

net <- graph.data.frame(df,directed = F)

cnet <- cluster_edge_betweenness(net)

plot(
  cnet,
  net,
  main = "Groups in the network",
  vertex.size = 10,
  vertex.label.cex = 0.8
)
