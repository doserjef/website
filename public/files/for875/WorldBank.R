u <- "https://www.finley-lab.com/files/data/WorldBank.csv"
WorldBank <- read.csv(u, header=TRUE, stringsAsFactors=FALSE)
fertility <- WorldBank$fertility.rate[WorldBank$year == 1960]
lifeexp <- WorldBank$life.expectancy[WorldBank$year==1960]
pop <- WorldBank$population[WorldBank$year==1960]
region <- WorldBank$region[WorldBank$year==1960]
plot(lifeexp, fertility, type="n")
symbols(lifeexp, fertility, circles=sqrt(pop/pi), inches=0.35, 
        bg=match(region, unique(region)))