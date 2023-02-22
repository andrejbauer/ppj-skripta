public class Point implements Movable {
	private int x;
	private int y;
	
	public Point(int x0, int y0) {
		this.x = x0;
		this.y = y0;
	}

	public int getX() {
		return x;
	}

	public int getY() {
		return y;
	}
	
	public void move(int dx, int dy) {
		this.x += dx;
		this.y += dy;
	}
}
