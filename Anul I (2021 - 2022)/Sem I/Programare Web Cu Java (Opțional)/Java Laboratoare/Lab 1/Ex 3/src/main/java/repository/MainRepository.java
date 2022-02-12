package repository;

import org.springframework.stereotype.Component;

@Component
public class MainRepository {

    public String sayHello() {
        return "Hello!";
    }
}
