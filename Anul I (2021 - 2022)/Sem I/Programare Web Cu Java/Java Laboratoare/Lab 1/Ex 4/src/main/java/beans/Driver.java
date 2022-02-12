package beans;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Driver {
    // Acum avem dependință Ciclică; (Eroare: circular reference)
    // Ca să scăpăm de ea, tb pus Autowired nu pe clasă, ci pe field
    @Autowired
    private Car car; // aici aveam și final inițial

//    @Autowired
//    public Driver(Car car) {
//        this.car = car;
//    }
}
