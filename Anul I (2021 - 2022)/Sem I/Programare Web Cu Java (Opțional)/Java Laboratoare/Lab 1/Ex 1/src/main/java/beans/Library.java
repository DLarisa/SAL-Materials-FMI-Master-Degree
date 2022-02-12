package beans;

import java.util.List;

public class Library {
    private String location;
    private List<Book> books;

    public Library(String location, List<Book> books) {
        this.location = location;
        this.books = books;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public List<Book> getBooks() {
        return books;
    }

    public void setBooks(List<Book> books) {
        this.books = books;
    }

    @Override
    public String toString() {
        return "Library{" +
                "location='" + location + '\'' +
                ", books=" + books +
                '}';
    }
}
