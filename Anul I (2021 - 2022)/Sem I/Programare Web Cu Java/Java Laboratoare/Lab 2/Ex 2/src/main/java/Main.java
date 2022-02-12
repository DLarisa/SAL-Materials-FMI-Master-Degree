import config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import utils.MessageService;

public class Main {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context =
                new AnnotationConfigApplicationContext(ProjectConfig.class);

        System.out.println("1: Context was created");
        /*
            Eager Instantiation -> default pt bean, aka se instanțiază când contextul este creat (Afișare: 2, 1, 3)
            Lazy Instantiation -> crează bean când el e folosit prima oară (Afișare: 1, 2, 3)
         */
        MessageService messageService = context.getBean(MessageService.class);
        messageService.printMessage();
        context.close();
    }
}
