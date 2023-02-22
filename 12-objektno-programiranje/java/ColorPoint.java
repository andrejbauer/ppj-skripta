import java.awt.Color;

public class ColorPoint extends Point {
	private Color color;
	
	public ColorPoint(int x0, int y0, Color c0) {
		super(x0, y0);
		this.color = c0;
	}
	
	public Color getColor() {
		return this.color;
	}
}
