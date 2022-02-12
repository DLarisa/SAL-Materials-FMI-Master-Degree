import config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import service.DatabaseConnectionService;

public class Main {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context =
                new AnnotationConfigApplicationContext(ProjectConfig.class);

        DatabaseConnectionService databaseConnectionService = context.getBean(DatabaseConnectionService.class);
        System.out.println(databaseConnectionService.getConnection());
    }
}
