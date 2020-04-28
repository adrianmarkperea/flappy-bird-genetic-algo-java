interface Activation {
    public double f(double x);
    public double d(double x);
}

class Sigmoid implements Activation {
    public double f(double x) {
        return 1 / (1 + Math.exp(-x));
    }

    public double d(double x) {
        println(x);
        return f(x) * (1 - f(x));
    }
}

class ReLU implements Activation {
    public double f(double x) {
        return Math.max(0, x);
    }

    public double d(double x) {
        return x <= 0 ? 0 : 1;
    }
}

class Brain {
    int numInputs;
    int numHidden;
    int numOutputs;

    Matrix weightsIL;
    Matrix weightsLO;
    
    Activation hiddenActivation;
    Activation outputActivation;

    public Brain(int numInputs_, int numHidden_, int numOutputs_,
            Activation hiddenActivation_, Activation outputActivation_) {
        numInputs = numInputs_;
        numHidden = numHidden_;
        numOutputs = numOutputs_;
        hiddenActivation = hiddenActivation_;
        outputActivation = outputActivation_;

        weightsIL = Matrix.rand(numInputs, numHidden); 
        weightsLO = Matrix.rand(numHidden, numOutputs);
    }

    public Brain clone() {
        Brain cloned = new Brain(numInputs, numHidden, numOutputs, hiddenActivation, outputActivation);
        cloned.setWeightsIL(weightsIL);
        cloned.setWeightsLO(weightsLO);
        return cloned;
    }

    public Matrix think(Matrix input) {
        Matrix L = input.times(weightsIL).applyActivation(hiddenActivation);
        Matrix O = L.times(weightsLO).applyActivation(outputActivation);

        return O;
    }

    public Matrix getWeightsIL() {
        return weightsIL;
    }

    public Matrix getWeightsLO() {
        return weightsLO;
    }

    public void setWeightsIL(Matrix weightsIL_) {
        // TODO: Raise error if shapes aren't the same.
        weightsIL = weightsIL_;
    }

    public void setWeightsLO(Matrix weightsLO_) {
        // TODO: Raise error if shapes aren't the same.
        weightsLO = weightsLO_;
    }
}
