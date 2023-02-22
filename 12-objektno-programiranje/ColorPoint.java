import java.awt.Color;

public class ColorPoint extends Point {
    private Color c;

    public ColorPoint(int x0, int y0, Color c0) {
        super(x0, y0) ;
        this.c = c0
    }

    @Override
    public void move(int dx, int dy) {
        super.move(dx, dy);
        this.c = new Color(0,0,0);
    }
}
