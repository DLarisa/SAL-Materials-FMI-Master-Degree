import beans.Book;
import beans.Library;
import config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Main {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context =
                new AnnotationConfigApplicationContext(ProjectConfig.class);

        // două posibilități de a prelua beanurile din context
        // 1. după nume (dar aici trebuie să facem noi cast; aka să specificăm clasa între paranteze)
        Book book = (Book) context.getBean("b1");
        System.out.println(book);

        // 2. după clasă (tip)
        Library library = context.getBean(Library.class);
        System.out.println(library);
    }
}
