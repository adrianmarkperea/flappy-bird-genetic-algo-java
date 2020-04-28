int numIndividuals = 300;

Population population;
ColumnManager columnManager;
Ground ground;
God god = new God();
int generation = 0;

void setup() {
    size(800, 800);
    population = new Population(numIndividuals);
    columnManager = new ColumnManager();
    ground = new Ground();
    println("Current Generation: " + generation);
}

void draw() {
    
    for (int i = 0; i < 3; i++) {
        population.hitSkyAny();
        population.hitColumnAny(columnManager);
        population.hitGroundAny(ground);

        population.attemptScoreAll(columnManager);
        
        population.thinkAll(columnManager);
        
        population.updateAll();
        columnManager.updateAll();

        if (population.allDead()) {
            population.calculateFitnessAll();
            println("Highest Score: " + population.getHighestFitness());
            population = god.reproduce(population);
            columnManager.reset();
            generation += 1;
            println("Current Generation: " + generation);
        }
    }


    background(54);
    population.drawAll();
    columnManager.drawAll();
    ground.draw();
}

