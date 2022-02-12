package com.java.proiect.model;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

@Component
@Lazy
public class MoneyConverter {
    private double price; // price in $;

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double convertToEuros(double price) {
        return price * 0.88;
    }

    public double convertToRon(double price) {
        return price * 5;
    }

    public double convertToWon(double price) {
        return price * 1187.95;
    }
}
