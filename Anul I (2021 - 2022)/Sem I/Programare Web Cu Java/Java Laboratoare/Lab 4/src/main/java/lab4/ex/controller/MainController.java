package lab4.ex.controller;

import lab4.ex.model.Animal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;

@RestController // ca să răspundă la http
@RequestMapping("/mainController")
public class MainController {
    private List<Animal> animalList = new ArrayList<>();

    /*
        Rest => Representational state transfer

        request (
            - va mapa un endpoint
            - caracterizat de un tip de operație dat de http verb (parametrii după caz)
            - conține header)
        <=> response (
            - http status code
            - datele de răspuns
            - error handling)
        =========================================================================================
        @PathVariable: citește valori din URL
        @RequestParam: des folosite pentru filtrări
        @RequestBody: în special pentru POST
     */

	//@PathVariable trimiți variabilă prin URL (să zicem ID unui produs)
    // Postman: GET -> localhost:8080/mainController/hello/world/ghici/ce
//    @GetMapping("/hello/{message}/ghici/{ceva}")
//    public String hello(@PathVariable String message, @PathVariable String ceva) {
//        return "Hello " + message + "!" + ceva;
//    }

	//@RequestParam: să zicem că faci o filtrare de tabel după chestii selectate de user
    // Postman: GET -> localhost:8080/mainController/hello?message=world&ceva=ce
//    @GetMapping("/hello")
//    public String hello(@RequestParam String message, @RequestParam String ceva) {
//        return "Hello " + message + "!" + ceva;
//    }

	// Nu prea e folosit cu GET @RequestBody; scop educativ
    // Postman: GET -> localhost:8080/mainController/hello & selectăm Body, Test și scriem acolo cuvântul
//    @GetMapping("/hello")
//    public String hello(@RequestBody String message) {
//        return "Hello " + message + "!";
//    }

//    @PostMapping("/newAnimal")
//    // Postman: POST -> localhost:8080/mainController/newAnimal
//    /*
//        Și în Body, JSON:
//        {
//            "nume": "Bobita",
//            "culoare": "negru"
//        }
//     */
//    public List<Animal> addAnimal(@RequestBody Animal animal) {
//        animalList.add(animal);
//        return animalList;
//    }

    @PostMapping("/newAnimal")
    public ResponseEntity<?> addAnimal(@RequestBody Animal animal) {
        if(animal.getCuloare().equalsIgnoreCase("alb")) {
            return ResponseEntity.ok(animal);
        } else {
            return ResponseEntity.badRequest().body(new Error("Animalul trebuie sa fie alb pentru a putea fi salvat"));
        }
        //return ResponseEntity.accepted().body(animal);
        //return ResponseEntity.created(URI.create("/newAnimal/" + animal.getCuloare())).body(animal);
        //return ResponseEntity.status(HttpStatus.NOT_EXTENDED).body(animal);
    }
}
