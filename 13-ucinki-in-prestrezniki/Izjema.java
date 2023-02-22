package izjeme;

public class Izjema {

	public static int f(int x) throws TooBig {
		if (x == 0)      { return 1 ; }
		else if (x == 1) { return 1 ; }
		else if (x > 30) { throw (new TooBig ()); } 
		else             { return f(x-1) + f(x-2); }
	}
	
	public static void main(String[] args) {
		try {
			int a = f(10);
			System.out.println("a = " + a);
			int b = f(50);
			System.out.println("b = " + b);
			int c = f(3);
			System.out.println("c = " + c);
		} catch (TooBig e) {
			System.out.println("Prišlo je do tehničnih motenj. Hvala za pozornost.");
		}
	}

}
