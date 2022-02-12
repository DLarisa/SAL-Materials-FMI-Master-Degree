package com.example.examen.repository;

import com.example.examen.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Integer> {
    List<Payment> findByPaymentType(String type);
    List<Payment> findByStatusType(String status);
    List<Payment> findByPaymentTypeAndStatusType(String type, String status);
}
