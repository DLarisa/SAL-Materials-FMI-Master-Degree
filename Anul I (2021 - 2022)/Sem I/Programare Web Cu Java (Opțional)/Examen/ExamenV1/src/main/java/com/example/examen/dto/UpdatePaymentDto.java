package com.example.examen.dto;

import javax.validation.constraints.NotNull;

public class UpdatePaymentDto extends CreatePaymentDto{
    @NotNull
    private int id;

    public UpdatePaymentDto(String paymentType, String customer, double amount, String statusType, int id) {
        super(paymentType, customer, amount, statusType);
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
