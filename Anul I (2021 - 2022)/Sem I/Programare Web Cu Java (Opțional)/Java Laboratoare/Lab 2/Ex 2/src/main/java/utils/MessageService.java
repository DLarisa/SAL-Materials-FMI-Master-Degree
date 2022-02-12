package utils;


import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

@Component
@Lazy // e bine ca orice nu ai nevoie la inițializare, să pui pe lazy (mai ales chestii mai rare and stuff' nu să pui acum toate beanurile pe lazy)
public class MessageService {
    public void printMessage() {
        System.out.println("3: Hi again on lab 2!");
    }

    @PostConstruct   //apelat înainte de orice într-un bean (primul lucru, el se apelează)
    public void init() {
        System.out.println("2: Initiating message service!");
    }

    @PreDestroy
    public void closing() {
        System.out.println("Bean has finished its job.");
    }
}
