package beans;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
// Problema e că avem 2 DatabaseConnection și Main nu știe pe care să îl apeleze
//@Primary (atunci va lua automat, mereu, pe cel primary) -> nu prea e folosit
@Qualifier("oracle") // efectiv e precum o etichetă și tu după scrii ce etichetă vrei să folosești
public class OracleDatabaseConnection implements DatabaseConnection {
    @Override
    public String getConnection() {
        return "Oracle";
    }
}
