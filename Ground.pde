class Ground {
    private int h = 50;

    public void draw() {
        fill(135);
        rect(0, height - h, width, height);
    }

    public boolean isCollided(Individual i) {
        return i.getBottomPoint() > height - h;
    }
}
