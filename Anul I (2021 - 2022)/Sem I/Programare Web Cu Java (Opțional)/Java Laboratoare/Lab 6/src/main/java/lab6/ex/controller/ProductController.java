package lab6.ex.controller;

import lab6.ex.exceptions.NoProductFoundException;
import lab6.ex.exceptions.NotSufficientQuantityException;
import lab6.ex.model.Product;
import lab6.ex.model.Shop;
import lab6.ex.repository.ShopProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.Min;

@RestController
@RequestMapping("/shop")
@Validated
public class ProductController {
    private final ShopProductRepository shopProductRepository;

    @Autowired
    public ProductController(ShopProductRepository shopProductRepository) {
        this.shopProductRepository = shopProductRepository;
    }

    @PostMapping("/product/new")
    public ResponseEntity<?> saveProduct(@RequestBody @Valid Product product) {
//        try {
            return ResponseEntity.ok().body(shopProductRepository.saveProduct(product));
//        } catch (NotSufficientQuantityException exception) {
//            return ResponseEntity.badRequest().body(exception.getMessage());
//        }
        // ar fi obositor să putem try-catch dacă aveam 50 de controlere, așa că folosim exceptionhandling -> ControllerAdvice
    }

    @GetMapping("/list")
    public ResponseEntity<Shop> shop() {
        return ResponseEntity.ok().body(shopProductRepository.retrieveShop());
    }

    @PostMapping("/product/buy/{productId}")
    public ResponseEntity<String> buyProduct(@PathVariable @Min(value = 7, message = "id must be bigger than 7") int productId) {
//        try {
            Product product = shopProductRepository.buyProduct(productId);
            return ResponseEntity.ok().body("You can buy more " + product.getQuantity() + " similar products.");
//        } catch (NoProductFoundException | NotSufficientQuantityException exception) {
//            return ResponseEntity.badRequest().body(exception.getMessage());
//        }
    }
}
