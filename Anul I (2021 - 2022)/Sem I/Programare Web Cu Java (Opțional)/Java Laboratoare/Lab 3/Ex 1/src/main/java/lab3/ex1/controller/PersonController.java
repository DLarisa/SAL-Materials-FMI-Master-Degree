package lab3.ex1.controller;

import lab3.ex1.model.Person;
import lab3.ex1.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping  // controller poate să accepte requesturi HTTP
public class PersonController {
    private final PersonService personService;

    @Autowired
    public PersonController(PersonService personService) {
        this.personService = personService;
    }

    @GetMapping("/")
    public String listPerson(Model model) {
        model.addAttribute("data", personService.retrieveAllPerson());
        return "index";
    }

    @GetMapping("/delete/{firstName}")
    public String deletePerson(Model model, @PathVariable String firstName) {
        personService.deletePerson(firstName);
        model.addAttribute("data", personService.retrieveAllPerson());
        return "index";
    }

    @PostMapping("/person/add")
    public String addPerson(@ModelAttribute("person") Person person, Model model){
        personService.addPerson(person);
        model.addAttribute("data", personService.retrieveAllPerson());
        return "index";
    }
}
