package com.example.examen.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class CreatePaymentDto {
    @NotBlank(message = "Payment Type cannot be null!")
    private String paymentType;

    @NotBlank(message = "Customer Name cannot be null!")
    @Size(max = 200)
    private String customer;

    private double amount;

    @NotBlank(message = "Status Type cannot be null!")
    private String statusType;

    public CreatePaymentDto() {
    }

    public CreatePaymentDto(String paymentType, String customer, double amount, String statusType) {
        this.paymentType = paymentType;
        this.customer = customer;
        this.amount = amount;
        this.statusType = statusType;
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
