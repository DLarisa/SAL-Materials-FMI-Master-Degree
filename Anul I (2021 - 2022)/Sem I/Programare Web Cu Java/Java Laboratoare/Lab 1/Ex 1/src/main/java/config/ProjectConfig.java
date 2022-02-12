package config;

import beans.Book;
import beans.Library;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;

@Configuration
public class ProjectConfig {

    @Bean
    public Book b1() {
        return new Book("Book 1", "Author 1");
    }

    @Bean
    public Book b2() {
        return new Book("Book 2", "Author 2");
    }

    @Bean
    public Library l1() {
        return new Library("Location 1", Arrays.asList(new Book("Book 3", "Author 3")));
    }
}
