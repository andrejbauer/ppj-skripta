public class Point {
    private int x ;
    private int y ;

    public Point(int x0, int y0) {
        this.x = x0;
        this.y = y0;
    }

    public Point(int x0) {
        this(x0, 0);
    }

    public int get_x() { return this.x; }

    public int get_y() { return this.y; }

    public void move(int dx, int dy) {
        this.x += dx;
        this.y += dy;
    }

    public void move() {
        this.x = 0;
        this.y = 0;
    }
}
