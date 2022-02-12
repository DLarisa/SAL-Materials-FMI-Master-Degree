package com.example.examen.model;

import javax.persistence.*;

@Entity
@Table(name = "payments")
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private int paymentId;

    @Column(name = "payment_type", nullable = false)
    private String paymentType;

    @Column(nullable = false)
    private String customer;

    @Column(nullable = false)
    private double amount;

    @Column(nullable = false)
    private String statusType;

    public Payment() {
    }

    public Payment(int paymentId, String paymentType, String customer, double amount, String statusType) {
        this.paymentId = paymentId;
        this.paymentType = paymentType;
        this.customer = customer;
        this.amount = amount;
        this.statusType = statusType;
    }

    public Payment(String paymentType, String customer, double amount, String statusType) {
        this.paymentType = paymentType;
        this.customer = customer;
        this.amount = amount;
        this.statusType = statusType;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getStatusType() {
        return statusType;
    }

    public void setStatusType(String statusType) {
        this.statusType = statusType;
    }
}
