package com.example.examen.mapper;

import com.example.examen.dto.CreatePaymentDto;
import com.example.examen.dto.UpdatePaymentDto;
import com.example.examen.model.Payment;
import org.springframework.stereotype.Component;

@Component
public class PaymentMapper {
    public Payment createPaymentDtoToPayment(CreatePaymentDto request) {
        return new Payment(request.getPaymentType(), request.getCustomer(),
                request.getAmount(), request.getStatusType());
    }

    public Payment updatePaymentDtoToPayment(UpdatePaymentDto request) {
        return new Payment(request.getId(), request.getPaymentType(), request.getCustomer(),
                request.getAmount(), request.getStatusType());
    }
}
