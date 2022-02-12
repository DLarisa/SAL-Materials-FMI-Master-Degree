import config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import service.MainService;

public class Main {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context =
                new AnnotationConfigApplicationContext(ProjectConfig.class);

        MainService mainService = context.getBean(MainService.class);
        System.out.println(mainService.sayHello());
    }
}
