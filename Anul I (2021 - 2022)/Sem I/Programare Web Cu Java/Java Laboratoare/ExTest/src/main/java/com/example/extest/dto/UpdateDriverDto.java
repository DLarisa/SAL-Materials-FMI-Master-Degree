package com.example.extest.dto;

import javax.validation.constraints.NotNull;

public class UpdateDriverDto extends CreateDriverDto{
    @NotNull
    private int id;

    public UpdateDriverDto(String name, String email, String city, int id) {
        super(name, email, city);
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
