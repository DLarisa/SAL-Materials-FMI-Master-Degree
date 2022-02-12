package lab3.ex1.service;

import lab3.ex1.model.Person;
import lab3.ex1.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PersonService {
    private final PersonRepository personRepository;

    @Autowired
    public PersonService(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    public List<Person> retrieveAllPerson() {
        return personRepository.retrieveAllPerson().stream().
                sorted(Comparator.comparing(Person::getFirstName)).collect(Collectors.toList());
    }

    public String addPerson(Person person) {
        return personRepository.addPerson(person);
    }

    public String deletePerson(String firstName) {
        return personRepository.deletePerson(firstName);
    }
}
