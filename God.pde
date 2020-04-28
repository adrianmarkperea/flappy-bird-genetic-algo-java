import java.util.Random;

class God {
    public Population reproduce(Population current) {
        Individual[] parents = current.getBestParents(50); 
        
        for (int p = 0; p < parents.length; p++) {
            print(parents[p].getFitness() + " ");
        } 

        println();

        Individual[] crossoverOffsprings = crossover(parents, current.getPopSize() - parents.length);
        Individual[] mutationOffsprings = mutate(crossoverOffsprings, 0.075);

        Individual[] newPopulation = new Individual[current.getPopSize()];
        for (int i = 0; i < parents.length; i++) {
            parents[i].reset();
            newPopulation[i] = parents[i];
        }

        for (int i = 0; i < mutationOffsprings.length; i++) {
            newPopulation[i + parents.length] = mutationOffsprings[i];
        }

        return new Population(newPopulation);
    }
    
    private Individual[] crossover(Individual[] parents, int numOffsprings) {
        Individual[] offsprings = new Individual[numOffsprings];

        Random rng = new Random();
        for (int i = 0; i < numOffsprings; i++) {
            int parentIndex1 = rng.nextInt(parents.length);
            int parentIndex2 = rng.nextInt(parents.length);

            Brain b1 = parents[parentIndex1].getBrain();  
            Brain b2 = parents[parentIndex2].getBrain();  

            Brain crossovered = uniformCrossover(b1, b2);
            offsprings[i] = new Individual(crossovered); 
        }    

        return offsprings;
    }

    private Brain uniformCrossover(Brain b1, Brain b2) {
        Matrix weightsIL1 = b1.getWeightsIL(); 
        Matrix weightsIL2 = b2.getWeightsIL();
        double[] flattenedWeightsIL1 = weightsIL1.getFlattened();
        double[] flattenedWeightsIL2 = weightsIL2.getFlattened();

        int ILLength = flattenedWeightsIL1.length;
        double[] newWeightsIL = new double[ILLength];
        for (int i = 0; i < ILLength; i++) {
            double chosenGene;
            if (tossCoin()) {
                chosenGene = flattenedWeightsIL1[i];
            } else {
                chosenGene = flattenedWeightsIL2[i];
            }

            newWeightsIL[i] = chosenGene;
        }

        Matrix weightsLO1 = b1.getWeightsLO(); 
        Matrix weightsLO2 = b2.getWeightsLO();
        double[] flattenedWeightsLO1 = weightsLO1.getFlattened();
        double[] flattenedWeightsLO2 = weightsLO2.getFlattened();

        int LOLength = flattenedWeightsLO1.length;
        double[] newWeightsLO = new double[LOLength];
        for (int i = 0; i < LOLength; i++) {
            double chosenGene;
            if (tossCoin()) {
                chosenGene = flattenedWeightsLO1[i];
            } else {
                chosenGene = flattenedWeightsLO2[i];
            }

            newWeightsLO[i] = chosenGene;
        }

        int ilM = weightsIL1.getM();
        int ilN = weightsIL1.getN();
        Matrix newWeightsILReshaped = Matrix.reshape(newWeightsIL, ilM, ilN);

        int loM = weightsLO1.getM();
        int loN = weightsLO1.getN();
        Matrix newWeightsLOReshaped = Matrix.reshape(newWeightsLO, loM, loN);

        Brain offspring = b1.clone();
        offspring.setWeightsIL(newWeightsILReshaped);
        offspring.setWeightsLO(newWeightsLOReshaped);

        return offspring;
        
    }

    private Individual[] mutate(Individual[] offsprings, float mutationChance) {
        Individual[] mutated = new Individual[offsprings.length];
        for (int i = 0; i < offsprings.length; i++) {
            Brain b = offsprings[i].getBrain();  
            Matrix weightsIL = b.getWeightsIL();  
            Matrix weightsLO = b.getWeightsLO();  

            Matrix mutatedWeightsIL = weightsIL.mutate(mutationChance);
            Matrix mutatedWeightsLO = weightsLO.mutate(mutationChance);

            Brain mutatedBrain = b.clone();
            mutatedBrain.setWeightsIL(mutatedWeightsIL);
            mutatedBrain.setWeightsLO(mutatedWeightsLO);

            mutated[i] = new Individual(mutatedBrain);
        }

        return mutated;
    }

    private boolean tossCoin() {
        return (new Random()).nextInt(2) == 1 ? true : false;
    }
}
