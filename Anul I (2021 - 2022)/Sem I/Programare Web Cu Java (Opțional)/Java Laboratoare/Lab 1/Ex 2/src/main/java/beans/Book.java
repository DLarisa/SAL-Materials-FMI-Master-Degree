package beans;

import org.springframework.stereotype.Component;

@Component
public class Book {
    private String title = "Book 1";
    private String author = "Author 1";

    /* Dacă o să decomentez constructorul, o să am eroare. La Ex1, cu Bean, aveam control total asupra lor
    * (puteam să modific date, etc...); dar la Component, nu mai merge. Component are mai mult sens pentru
    * o clasă de Service sau Audit. Oricum, best practice e mai mult cu cele Component și alte stereotipuri. */
//    public Book(String title, String author) {
//        this.title = title;
//        this.author = author;
//    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    @Override
    public String toString() {
        return "Book{" +
                "title='" + title + '\'' +
                ", author='" + author + '\'' +
                '}';
    }
}
