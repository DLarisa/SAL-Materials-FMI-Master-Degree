package lab3.ex1.repository;

import lab3.ex1.model.Person;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class PersonRepository {
    private static List<Person> personList = new ArrayList<>();

    public PersonRepository() {
        Person p1 = new Person("P2 FirstN", "P2 LastN", 23);
        Person p2 = new Person("P1 FirstN", "P1 LastN", 25);
        Person p3 = new Person("P3 FirstN", "P3 LastN", 27);

        personList.add(p1); personList.add(p2); personList.add(p3);
    }

    public List<Person> retrieveAllPerson() {
        return personList;
    }

    public String addPerson(Person person) {
        personList.add(person);
        return "A new person was added.";
    }

    public String deletePerson(String firstName) {
        personList = personList.stream().filter(person -> !person.getFirstName().equals(firstName)).
                collect(Collectors.toList());
        return "Person with name " + firstName + " was deleted.";
    }
}
