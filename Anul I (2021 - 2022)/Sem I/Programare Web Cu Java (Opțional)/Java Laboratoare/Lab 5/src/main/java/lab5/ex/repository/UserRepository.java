package lab5.ex.repository;

import lab5.ex.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/*Recomandabil este ca în Repository sa luăm doar datele din baza de date.
Loggerul și toate prelucrările să fie în service.*/

@Repository
public class UserRepository {
    private static List<User> userList = new ArrayList<>();
    Logger logger = LoggerFactory.getLogger(UserRepository.class);

    // nu mai folosim adnotările de lombok pt că nu ne-ar lăsa să hardcodăm datele
    public UserRepository() {
        User u1 = new User(1, "Username1", "FirstName1", "LastName1",
                "email1", "address1", "contact1");
        User u2 = User.builder().id(2).
                userName("Username2").
                firstName("FirstName2").
                lastName("LastName2").
                build();

        userList.add(u1); userList.add(u2);
    }

    public List<User> findAll() {
        logger.info("returning to user {}", userList);
        return userList;
    }

    public User save(User user) {
        logger.info("saving user {}, user {} saved", user, user);
        userList.add(user);
        return user;
    }

    public void deleteById(int userId) {
        logger.info("delete user with id {}", userId);
        userList = userList.stream().
                filter(u -> u.getId() != userId).
                collect(Collectors.toList());
    }

    public Optional<User> findById(int userId) {
        logger.info("retrieved user with id {}", userId);
        return userList.stream().
                filter(user -> user.getId() == userId).
                findFirst();
    }
}
