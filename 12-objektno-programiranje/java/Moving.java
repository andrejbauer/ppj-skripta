import java.util.List;

public abstract class Moving {
	public abstract void move(int dx, int dy);
	
	public void many_moves(List<Premik> lst) {
		for (Premik p : lst) {
			this.move(p.dx, p.dy);
		}
	}
}
