import java.util.ArrayList;
import java.util.List;

public class Demo {
	
	public static void many_moves(Movable o, List<Premik> lst) {
		for (Premik p : lst) {
			o.move(p.dx, p.dy);
		}
	}
	
	public static int f(int x) { return x + 10; }
	
	public static boolean f(double y) { return (y < 10.0); }
	
	public static double f(double y, double z) { return y * y - z * z; }
	
	public static double f(double y, int z) { return y * y + z * z; }

	public static double f(int y, double z) { return 42.0; }

	public static void main(String[] args) {

		Movable o = new Silly(16);
		if (System.currentTimeMillis() % 7 < 3) {
			o = new Point(10, 20);
		}
		o.move(3, 4); // to deluje
		// To ne deluje: int x = o.getX();
		// To "deluje":
		int x = ((Point)o).getX();
		System.out.println(x);

		int a = f(10);
		boolean b = f(3.14);
		double c = f(1.2, 42);
		System.out.println(c);
		// Ne deluje: double d = f(1, 2);
		// System.out.println(d);
		
		// Seznami
		ArrayList<String> mojSeznam = new ArrayList<String>();

	}

}
