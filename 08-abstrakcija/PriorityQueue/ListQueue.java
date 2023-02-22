import java.util.LinkedList;

public class ListQueue<Element extends Priority> implements PriorityQueue<Element> {
    private LinkedList<Element> elements;

    public ListQueue() {
        elements = new LinkedList<Element>();
    }

    @Override
    public boolean isEmpty() {
        return elements.isEmpty();
    }

    @Override
    public void put(Element x) {
        int i = 0;
        for (Element y : elements) {
            if (x.priority() < y.priority()) {
                break;
            } else {
                i += 1;
            }
        }
        elements.add(i, x);
    }

    @Override
    public Element get() {
        return elements.removeFirst();
    }

    @Override
    public PriorityQueue<Element> emptyQueue() {
        return new ListQueue<Element>();
    }
}
