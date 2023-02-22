public class Par<A,B> {
    private A first;
    private B second;

    public Par(A x, B y) {
        this.first = x;
        this.second = y;
    }

    public A get_first() {
        return this.first;
    }

    public B get_second() {
        return this.second;
    }
}
