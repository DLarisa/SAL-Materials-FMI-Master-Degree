package com.example.examen.service;

import com.example.examen.exceptions.*;
import com.example.examen.model.Payment;
import com.example.examen.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {
    public final PaymentRepository paymentRepository;

    @Autowired
    public PaymentService(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    public Payment create(Payment payment) {
        checkDoublePositive(payment);
        checkPaymentType(payment);
        checkStatusType(payment);
        return paymentRepository.save(payment);
    }

    private void checkStatusType(Payment payment) {
        if(!payment.getStatusType().equals("NEW") ||
                !payment.getStatusType().equals("PROCESSED") ||
                !payment.getStatusType().equals("CANCELLED")) {
            throw new PaymentStatusTypeError();
        }
    }

    private void checkPaymentType(Payment payment) {
        if(!payment.getPaymentType().equals("POS") ||
                !payment.getPaymentType().equals("ONLINE")) {
            throw new PaymentTypeError();
        }
    }

    private void checkDoublePositive(Payment payment) {
        if(payment.getAmount() < 0) {
            throw new NegativeAmountError();
        }
    }

    @Transactional
    public Payment update(Payment payment) {
        Optional<Payment> foundPayment = paymentRepository.findById(payment.getPaymentId());
        if(foundPayment.isEmpty()) {
            throw new PaymentNotFoundError();
        }
        if(foundPayment.get().getStatusType().equals("CANCELLED")) {
            throw new PaymentAlreadyCancelled();
        }
        return paymentRepository.save(payment);
    }

    public List<Payment> get(String type, String status) {
        if(type != null) {
            if(status != null) {
                return paymentRepository.findByPaymentTypeAndStatusType(type, status);
            }
            return paymentRepository.findByPaymentType(type);
        }
        if(status != null) {
            return paymentRepository.findByStatusType(status);
        }
        return paymentRepository.findAll();
    }
}
