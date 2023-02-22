public interface PriorityQueue<Element extends Priority> {
    public PriorityQueue<Element> emptyQueue();
    public boolean isEmpty();
    public void put(Element x);
    public Element get();
}
