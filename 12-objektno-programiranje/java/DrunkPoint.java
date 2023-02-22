
public class DrunkPoint extends Point {
	public DrunkPoint(int x0, int y0) {
		super(x0, y0);
	}

	@Override
	public void move(int dx, int dy) {
		super.move(dx + 2, dy - 3);
	}
	
	
}
