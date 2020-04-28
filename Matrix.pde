static class Matrix {
    private final int M;
    private final int N;
    private final double[][] data;

    public Matrix(int M, int N) {
        this.M = M;
        this.N = N;
        data = new double[M][N];
    }

    public Matrix(double[][] data) {
        M = data.length;
        N = data[0].length;
        this.data = new double[M][N];
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                    this.data[i][j] = data[i][j];
    }

    private Matrix(Matrix A) { this(A.data); }

    public static Matrix rand(int M, int N) {
        Matrix A = new Matrix(M, N);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                A.data[i][j] = Math.random() * 2 - 1;
        return A;
    }

    public static Matrix identity(int N) {
        Matrix I = new Matrix(N, N);
        for (int i = 0; i < N; i++)
            I.data[i][i] = 1;
        return I;
    }

    public double at(int i, int j) {
        return data[i][j];
    }

    private void swap(int i, int j) {
        double[] temp = data[i];
        data[i] = data[j];
        data[j] = temp;
    }

    public Matrix T() {
        Matrix A = new Matrix(N, M);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                A.data[j][i] = this.data[i][j];
        return A;
    }

    public Matrix plus(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(M, N);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                C.data[i][j] = A.data[i][j] + B.data[i][j];
        return C;
    }

    public Matrix minus(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(M, N);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                C.data[i][j] = A.data[i][j] - B.data[i][j];
        return C;
    }

    public boolean eq(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                if (A.data[i][j] != B.data[i][j]) return false;
        return true;
    }

    public Matrix times(Matrix B) {
        Matrix A = this;
        if (A.N != B.M) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(A.M, B.N);
        for (int i = 0; i < C.M; i++)
            for (int j = 0; j < C.N; j++)
                for (int k = 0; k < A.N; k++)
                    C.data[i][j] += (A.data[i][k] * B.data[k][j]);
        return C;
    }

    public Matrix applyActivation(Activation activation) {
        Matrix A = this;
        Matrix B = new Matrix(A.M, A.N);            

        for (int i = 0; i < M; i++) {
            for (int j = 0; j < N; j++) {
                B.data[i][j] = activation.f(A.data[i][j]);
            }
        }

        return B;
    } 

    public void show() {
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < N; j++) {
                print(data[i][j]);
                print(" ");
            }
            println();
        }
    }

    public double[] getFlattened() {
        double[] flattened = new double[M*N];
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < N; j++) {
                flattened[i*N + j] = data[i][j];
            }
        }

        return flattened;
    }

    public static Matrix reshape(double[] data, int M_, int N_) {
        double[][] reshaped = new double[M_][N_]; 
        for (int i = 0; i < M_; i++) {
            for (int j = 0; j < N_; j++) {
                reshaped[i][j] = data[i*N_ + j];
            }
        }

        return new Matrix(reshaped);
    }

    public int getM() {
        return M;
    }

    public int getN() {
        return N;
    }

    public Matrix mutate(float mutationChance) {
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < N; j++) {
                boolean doMutation = Math.random() <= mutationChance;
                if (doMutation) {
                    data[i][j] += (Math.random()*10 - 5);
                }
            }
        }

        return this;
    }
}
