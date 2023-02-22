
public class Silly implements Movable {
	private int y;
	
	public Silly(int y0) { this.y = y0; }

	public int getY() { return this.y; }
	
	public void move(int dx, int dy) {
		this.y += dy;		
	}
	
	

}
