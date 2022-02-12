package com.example.examen.service;

import com.example.examen.exceptions.NegativeAmountError;
import com.example.examen.model.Payment;
import com.example.examen.repository.PaymentRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class PaymentServiceTest {
    @InjectMocks
    private PaymentService paymentService;

    @Mock
    private PaymentRepository paymentRepository;

    @Test
    @DisplayName("Payment is created successfully")
    void create() {
        Payment payment = new Payment("POS", "A", 20.00, "NEW");
        when(paymentRepository.save(payment)).thenReturn(payment);

        Payment result = paymentService.create(payment);

        assertNotNull(result);
        assertEquals(payment.getPaymentId(), result.getPaymentId());
        assertEquals(payment.getPaymentType(), result.getPaymentType());
        assertEquals(payment.getCustomer(), result.getCustomer());
        assertEquals(payment.getAmount(), result.getAmount());
        assertEquals(payment.getStatusType(), result.getStatusType());

        verify(paymentRepository).save(payment);
    }

    @Test
    @DisplayName("Payment not created - amount negative")
    void createAmountThrowsError() {
        Payment payment = new Payment("POS", "A", -20.00, "NEW");

        NegativeAmountError error = assertThrows(NegativeAmountError.class,
                () -> paymentService.create(payment));

        assertNotNull(error);
        assertEquals("Amount cannot be negative!", error.getMessage());
        verify(paymentRepository, times(0)).save(payment);
    }

    @Test
    @DisplayName("Payment customer is updated successfully")
    void updateCustomer() {
        Payment oldPayment = new Payment("POS", "A", 20.00, "NEW");
        Payment newPayment = new Payment("POS", "AB", 20.00, "NEW");
        when(paymentRepository.findById(oldPayment.getPaymentId())).thenReturn(Optional.of(oldPayment));
        when(paymentRepository.save(newPayment)).thenReturn(newPayment);

        Payment result = paymentService.update(newPayment);

        assertNotNull(result);
        assertEquals(newPayment.getPaymentId(), result.getPaymentType());
        assertEquals(newPayment.getPaymentType(), result.getPaymentType());
        assertEquals(newPayment.getCustomer(), result.getCustomer());
        assertEquals(newPayment.getAmount(), result.getAmount());
        assertEquals(newPayment.getStatusType(), result.getStatusType());

        verify(paymentRepository).findById(newPayment.getPaymentId());
        verify(paymentRepository).save(newPayment);
    }

    @Test
    @DisplayName("Get payments by type")
    void getByType() {
        String type = "POS";
        Payment payment = new Payment(1, "POS", "A", -20.00, "NEW");
        when(paymentRepository.findByPaymentType(type)).thenReturn(List.of(payment));

        List<Payment> paymentList = paymentService.get(type, null);

        assertNotNull(paymentList);
        assertEquals(1, paymentList.size());
        assertEquals(payment, paymentList.get(0));

        verify(paymentRepository).findByPaymentType(type);
        verify(paymentRepository, never()).findByPaymentTypeAndStatusType(any(), any());
        verify(paymentRepository, never()).findByStatusType(any());
        verify(paymentRepository, never()).findAll();
    }

    @Test
    @DisplayName("Get payments by status")
    void getByStatus() {
        String status = "NEW";
        Payment payment = new Payment(1, "POS", "A", -20.00, "NEW");
        when(paymentRepository.findByStatusType(status)).thenReturn(List.of(payment));

        List<Payment> paymentList = paymentService.get(null, status);

        assertNotNull(paymentList);
        assertEquals(1, paymentList.size());
        assertEquals(payment, paymentList.get(0));

        verify(paymentRepository).findByStatusType(status);
        verify(paymentRepository, never()).findByPaymentTypeAndStatusType(any(), any());
        verify(paymentRepository, never()).findByPaymentType(any());
        verify(paymentRepository, never()).findAll();
    }

    @Test
    @DisplayName("Get all payments - no filters")
    void getAll() {
        Payment payment = new Payment(1, "POS", "A", -20.00, "NEW");
        when(paymentRepository.findAll()).thenReturn(List.of(payment));

        List<Payment> result = paymentService.get(null, null);

        //assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(payment, result.get(0));

        verify(paymentRepository, never()).findByPaymentType(any());
        verify(paymentRepository, never()).findByPaymentTypeAndStatusType(any(), any());
        verify(paymentRepository, never()).findByStatusType(any());
        verify(paymentRepository).findAll();
    }
}
