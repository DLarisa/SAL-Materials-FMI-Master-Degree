package beans;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Car {
    // Acum avem dependință Ciclică; (Eroare: circular reference)
    // Ca să scăpăm de ea, tb pus Autowired nu pe clasă, ci pe field
    @Autowired
    private Driver driver; // aici aveam și final, inițial

//    @Autowired
//    public Car(Driver driver) {
//        this.driver = driver;
//    }
}
