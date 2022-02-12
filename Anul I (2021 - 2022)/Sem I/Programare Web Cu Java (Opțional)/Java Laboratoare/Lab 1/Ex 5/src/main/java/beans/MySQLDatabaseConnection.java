package beans;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
@Qualifier("mysql")
public class MySQLDatabaseConnection implements DatabaseConnection {
    @Override
    public String getConnection() {
        return "MySQL";
    }
}
