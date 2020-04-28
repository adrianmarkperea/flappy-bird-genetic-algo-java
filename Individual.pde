class Individual implements java.lang.Comparable<Individual> {
    private int x;
    private int y;
    private int radius;
    
    private float gravity;
    private float trueSpeed;
    private int speed;
    private int jumpSpeed; 

    private int score;
    private int fitness;
    private boolean isDead;

    private Brain brain;

    public Individual() {
        reset();
        brain = new Brain(5, 3, 1, new ReLU(), new Sigmoid());
    }

    public Individual(Brain brain_) {
        reset();
        brain = brain_;
    }

    public void reset() {
        x = 50; 
        y = (int)(height * 0.75) + (int)(random(-10, 10));
        radius = 12;

        gravity = 0.4;
        trueSpeed = -4;
        jumpSpeed = 8;

        isDead = false;
        
        score = 0;
        fitness = 0;
    }

    public void draw() {
        if (isDead) {
            return;
        }

        fill(225);
        noStroke();
        ellipse(x, y, radius*2, radius*2);
    }

    public void think(Matrix input) {
        Matrix thoughts = brain.think(input);

        // println(thoughts.at(0, 0));

        if (thoughts.at(0, 0) >= 0.5) {
            up();
        }
    }

    public void update() {
        if (isDead) {
            return;
        }

        fitness += 1;

        trueSpeed += gravity;
        speed = (int)trueSpeed;
        y += speed;    
    }

    public void up() {
        trueSpeed = -jumpSpeed;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }
    
    public int getRadius() {
        return radius;
    }

    public int getTopPoint() {
        return y - radius;
    }

    public int getBottomPoint() {
        return y + radius;
    }
    
    public int getRightPoint() {
        return x + radius;
    }

    public int getLeftPoint() {
        return x - radius;
    }

    public int getScore() {
        return score;
    }

    public void attemptScore(Column col) {
        if (getLeftPoint() > (col.getX() + col.getWidth())) {
            score++;
        }
    }

    public void calculateFitness() {
        fitness += score * 10;
    }
    
    public void die() {
        isDead = true;
    }

    public boolean isDead() {
        return isDead;
    }

    public int getFitness() {
        return fitness;
    }

    public int compareTo(Individual i2) {
        Individual i1 = this;

        int res = 0;
        if (i1.getFitness() > i2.getFitness()) {
            res = -1;
        } else if (i1.getFitness() < i2.getFitness()) {
            res = 1;
        }

        return res;
    }

    public Brain getBrain() {
        return brain;
    }
}
