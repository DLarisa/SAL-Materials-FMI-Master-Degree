package lab6.ex.exceptionhandling;

import lab6.ex.exceptions.NoProductFoundException;
import lab6.ex.exceptions.NotSufficientQuantityException;
import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@ControllerAdvice
public class GlobalExceptionHandler {

//    @ExceptionHandler(NotSufficientQuantityException.class)
//    public ResponseEntity<?> handleException(NotSufficientQuantityException e) {
//        Map<String, String> responseParameters = new HashMap<>();
//        responseParameters.put("Reason: ", e.getMessage());
//        responseParameters.put("DateTime:", LocalDateTime.now().toString());
//
//        return ResponseEntity.badRequest().body(responseParameters);
//    }

    @ExceptionHandler({NotSufficientQuantityException.class, NoProductFoundException.class})
    public ResponseEntity<?> handleException(RuntimeException e) {
        Map<String, String> responseParameters = new HashMap<>();
        responseParameters.put("Reason: ", e.getMessage());
        responseParameters.put("DateTime:", LocalDateTime.now().toString());

        return ResponseEntity.badRequest().body(responseParameters);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object >> handleAPIValidationForClasses(MethodArgumentNotValidException e) {
        Map<String, Object> responseParameters = new HashMap<>();
        List<String> errors = e.getBindingResult().getAllErrors().
                stream().
                map(DefaultMessageSourceResolvable::getDefaultMessage).
                collect(Collectors.toList());

        responseParameters.put("Reason: ", errors);
        responseParameters.put("DateTime:", LocalDateTime.now().toString());

        return ResponseEntity.badRequest().body(responseParameters);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<Map<String, Object>> handleApiValidationForParameters(ConstraintViolationException exception){
        Map<String, Object> responseParameters = new HashMap<>();
        List<String> errors = exception.getConstraintViolations()
                .stream()
                .map(ConstraintViolation::getMessage)
                .collect(Collectors.toList());

        responseParameters.put("Reason: ", errors);
        responseParameters.put("DateTime: ", LocalDateTime.now().toString());

        return ResponseEntity.badRequest().body(responseParameters);
    }
}
