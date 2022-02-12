import config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import utils.MessageService;

public class Main {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context =
                new AnnotationConfigApplicationContext(ProjectConfig.class);

        /*
            SCOPURI BEANS:
            Default, bean-urile sunt singleton pe context de Spring
            prototype -> va servi un nou bean pt fiecare apel
            =======================================================
            SCOPURI BEAN(în contextul unei aplicații web; cu API and stuff):
            request -> bean per request
            session -> bean per session
            application -> bean per application
         */
        /*
            Când avem @Autowired, dacă vrem să injectăm un prototype într-un Bean default (singleton),
            singleton-ul o să oblige prototype-ul să fie creat o singură dată.
         */
        System.out.println("Context was created!");
        MessageService messageService1 = context.getBean(MessageService.class);
        messageService1.setMessage("Hold on a second!");
        System.out.println("Msg1: " + messageService1.getMessage());

        MessageService messageService2 = context.getBean(MessageService.class);
        System.out.println("Msg2: " + messageService2.getMessage());
        /*
            Dacă lăsam fără scopul de prototype, era printat același mesaj de 2 ori, pt că era singleton.
            Pt că avem prototype, ni se dă un bean și al doilea mesaj va fi null.
         */
    }
}
