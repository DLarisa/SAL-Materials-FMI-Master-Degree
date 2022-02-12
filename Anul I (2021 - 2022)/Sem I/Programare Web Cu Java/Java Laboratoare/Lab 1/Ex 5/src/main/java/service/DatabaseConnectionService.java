package service;

import beans.DatabaseConnection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class DatabaseConnectionService {
    @Autowired
    @Qualifier("oracle")
//    @Qualifier("mysql")
    DatabaseConnection databaseConnection;

    public String getConnection() {
        return databaseConnection.getConnection();
    }
}
