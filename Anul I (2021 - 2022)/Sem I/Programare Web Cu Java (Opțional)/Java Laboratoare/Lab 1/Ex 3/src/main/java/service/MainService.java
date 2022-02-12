package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import repository.MainRepository;

@Component
public class MainService {
    // sau puteam să pun direct aici Autowired și să nu mai am constructorul și mergea (dar fără final)
    // e recomandat să folosim final pt imutabilitate și teste unitare
    private final MainRepository mainRepository;

    /*
            3 Posibilități de a folosi Autowired
            1) pe Field
            2) pe Constructor -> RECOMANDAT
            3) pe Setter -> foarte foarte rar
     */
    @Autowired // modalitatea prin care Spring face dependency injection (obiect primește un alt obiect de care depinde -> moștenire)
    // aka autowired zice Springului să aducă bean-ul de MainRepository ca să îl folosească
    public MainService(MainRepository mainRepository) {
        this.mainRepository = mainRepository;
    }

    public String sayHello() {
        return mainRepository.sayHello();
    }
}
