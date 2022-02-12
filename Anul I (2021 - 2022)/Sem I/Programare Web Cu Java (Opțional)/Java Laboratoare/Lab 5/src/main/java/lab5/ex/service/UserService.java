package lab5.ex.service;

import lab5.ex.model.User;
import lab5.ex.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/*Recomandabil este ca în Repository sa luăm doar datele din baza de date.
Loggerul și toate prelucrările să fie în service.*/

@Service
@AllArgsConstructor // e fix constructorul de mai jos, cu tot cu autowired
public class UserService {
    private final UserRepository userRepository;

    /*@Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }*/

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    public void deleteById(int userId) {
        userRepository.deleteById(userId);
    }

    public User findById(int userId) {
        return userRepository.findById(userId).
                orElseThrow(() -> new RuntimeException("User was not found"));
    }
}
