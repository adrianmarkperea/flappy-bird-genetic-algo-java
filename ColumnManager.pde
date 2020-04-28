class ColumnManager {
    private int columnStart; 
    private int columnSpacing;

    private int closestColumnIndex;
    private int furthestColumnIndex;
    private int targetColumnIndex;
    
    private Column[] columns;

    public ColumnManager() {
        columnStart = (int)(width/2);
        columnSpacing = 500;  
        columns = initializeColumns();
    }

    private Column[] initializeColumns() {
        // +1 for buffer
        int maxColumnsOnScreen = (int)(width/(50 + columnSpacing)) + 1;

        Column[] columns_ = new Column[maxColumnsOnScreen];
        for (int i = 0; i < maxColumnsOnScreen; i++) {
            columns_[i] = new Column(columnStart + i*columnSpacing);
        }

        closestColumnIndex = 0;
        furthestColumnIndex = columns_.length - 1;
        targetColumnIndex = closestColumnIndex;

        return columns_;
    }

    public void drawAll() {
        for (Column c : columns) {
            c.draw();
        } 
    }
    
    public void updateAll() {
        for (Column c : columns) {
            c.update();
        }

        if (columns[targetColumnIndex].hasPassedPlayer()) {
            setNextTarget();
        }

        if (columns[closestColumnIndex].isOffScreen()) {
            relocate();
        } 
    }

    public boolean isCollidedAny(Individual i) {
        boolean isCollidedAny = false;
        for (Column c : columns) {
            if (c.isCollided(i)) {
                isCollidedAny = true;
                break;
            }
        }
        
        return isCollidedAny;
    }

    public Column getClosestColumn() {
        return columns[closestColumnIndex];
    }

    public Column getTargetColumn() {
        return columns[targetColumnIndex];
    }

    private void setNextTarget() {
        targetColumnIndex = (targetColumnIndex + 1) % columns.length;
    }

    private void relocate() {
        columns[closestColumnIndex].relocate(columns[furthestColumnIndex].x + columnSpacing);
        furthestColumnIndex = closestColumnIndex;
        closestColumnIndex = (closestColumnIndex + 1) % columns.length;
    }

    public void reset() {
        columns = initializeColumns();
    }
}
