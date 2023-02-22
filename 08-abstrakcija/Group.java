public interface Group<G> {
    public G getUnit();
    public G multiply(G x, G y);
    public G inverse(G x);
}
