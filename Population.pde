import java.util.Arrays;
import java.util.Collections;

class Population {
    private Individual[] population;

    private int popSize;

    public Population(int numIndividuals) {
        population = new Individual[numIndividuals]; 
        for (int i = 0; i < numIndividuals; i++) {
            population[i] = new Individual();
        }

        popSize = numIndividuals;
    }

    public Population(Individual[] population_) {
        population = population_;
        popSize = population_.length;
    }

    public void drawAll() {
        for (Individual individual : population) {
            individual.draw();
        }
    }

    public void thinkAll(ColumnManager columnManager) {
        Column target = columnManager.getTargetColumn();

        for (Individual individual : population) {
            double[][] input = new double[1][5];
            input[0][0] = individual.getY() / (double)(height);
            input[0][1] = target.getCenter() / (double)(height); 
            input[0][2] = target.getX() / (double)(width);
            input[0][3] = (target.getCenter() - target.getOpening()) / (double)(height);
            input[0][4] = (target.getCenter() + target.getOpening()) / (double)(height);
             
            individual.think(new Matrix(input));
        }
    }

    public void updateAll() {
        for (Individual individual : population) {
            individual.update();
        }                                              
    }

    public void hitColumnAny(ColumnManager columnManager) {
        for (Individual individual : population) {
            if (columnManager.isCollidedAny(individual)) {
                individual.die();
            }
        }
    }

    public void hitGroundAny(Ground ground) {
       for (Individual individual : population) {
            if (ground.isCollided(individual)) {
                individual.die();
            }
        } 
    }

    public void hitSkyAny() {
        for (Individual individual : population) {
            if (individual.getTopPoint() < 0) {
                individual.die();
            }
        }
    }

    public void attemptScoreAll(ColumnManager columnManager) {
        for (Individual individual : population) {
            individual.attemptScore(columnManager.getClosestColumn());
        } 
    }

    public void calculateFitnessAll() {
        for (Individual individual : population) {
            individual.calculateFitness();
        }
    }

    public boolean allDead() {
        boolean allDead = true;
        for (Individual individual : population) {
            if (!individual.isDead()) {
                allDead = false; 
            }
        }

        return allDead;
    }

    public Individual[] getBestParents(int numParents) {
        
        Arrays.sort(population);

        return Arrays.copyOfRange(population, 0, numParents);

    }

    public int getPopSize() {
        return popSize;
    }

    public int getHighestFitness() {
        return getBestParents(1)[0].getFitness();
    }

}
