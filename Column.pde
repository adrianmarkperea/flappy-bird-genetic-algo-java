class Column {
    private int x;
    private int w;

    private int opening;
    private int minCenterHeight;
    private int maxCenterHeight;
    private int center;

    private int topColumnY;
    private int topColumnHeight;

    private int bottomColumnY;
    private int bottomColumnHeight;

    private int pan;

    public Column(int x_) {
        x = x_;
        w = 50;
        opening = 150;
        minCenterHeight = opening; 
        maxCenterHeight = height - opening - 50;
        calculateCenter();

        pan = 3;
    }

    public void draw() {
        fill(225); 
        noStroke();
        rect(x, 0, w, center - opening/2);
        rect(x, center + opening/2, w, height - 50 - (center + opening/2));
    }

    public void update() {
        x -= pan;
    }
    
    public boolean isCollided(Individual i) {
        boolean collideBottomY = (i.getBottomPoint() > bottomColumnY)
                                 && (i.getBottomPoint() < bottomColumnY + bottomColumnHeight);
        boolean collideTopY = (i.getTopPoint() > topColumnY)
                              && (i.getTopPoint() < topColumnY + topColumnHeight);
        boolean collideRightX = (i.getRightPoint() > x) && (i.getRightPoint() < x + w);
        boolean collideLeftX = (i.getLeftPoint()) > x && (i.getLeftPoint() < x + w);

        return (collideRightX || collideLeftX) && (collideTopY || collideBottomY);
    }

    private void calculateCenter() {
        center = (int)(random(1) * (maxCenterHeight - minCenterHeight + 1) + minCenterHeight);
        topColumnY = 0;
        topColumnHeight = center - opening/2;
    
        bottomColumnY = center + opening/2;
        bottomColumnHeight = height - 50 - (center + opening/2);
    }

    public boolean isOffScreen() {
        return x + w < 0;
    }

    public boolean hasPassedPlayer() {
        return x + w < 36;
    }

    public void relocate(int x_) {
        x = x_;
        calculateCenter();
    }

    public int getX() {
        return x;
    }

    public int getWidth() {
        return w;
    }

    public int getCenter() {
        return center;
    }

    public int getOpening() {
        return opening; 
    }
}
