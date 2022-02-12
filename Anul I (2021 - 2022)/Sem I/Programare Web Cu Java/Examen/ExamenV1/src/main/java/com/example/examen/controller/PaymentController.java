package com.example.examen.controller;

import com.example.examen.dto.CreatePaymentDto;
import com.example.examen.dto.UpdatePaymentDto;
import com.example.examen.exceptions.InvalidCancelRequestError;
import com.example.examen.mapper.PaymentMapper;
import com.example.examen.model.Payment;
import com.example.examen.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/payment")
@Validated
public class PaymentController {
    private final PaymentService paymentService;
    private final PaymentMapper paymentMapper;

    @Autowired
    public PaymentController(PaymentService paymentService, PaymentMapper paymentMapper) {
        this.paymentService = paymentService;
        this.paymentMapper = paymentMapper;
    }

    // Add a new payment
    @PostMapping
    public ResponseEntity<?> add(@Valid
                                 @RequestBody CreatePaymentDto request) {
        Payment payment = paymentService.create(paymentMapper.createPaymentDtoToPayment(request));
        return ResponseEntity.created(URI.create("/payment/" + payment.getPaymentId())).body(payment);
    }

    // Cancel a payment
    @PutMapping("/{id}")
    public ResponseEntity<?> cancel(@PathVariable int id,
                                    @Valid
                                    @RequestBody UpdatePaymentDto request) {
        if(id != request.getId()) {
            throw new InvalidCancelRequestError();
        }
        Payment payment = paymentService.update(paymentMapper.updatePaymentDtoToPayment(request));
        return ResponseEntity.ok(payment);
    }

    // Get payments
    @GetMapping
    public List<Payment> get(@RequestParam(required = false) String type,
                             @RequestParam(required = false) String status) {
        return paymentService.get(type, status);
    }
}
