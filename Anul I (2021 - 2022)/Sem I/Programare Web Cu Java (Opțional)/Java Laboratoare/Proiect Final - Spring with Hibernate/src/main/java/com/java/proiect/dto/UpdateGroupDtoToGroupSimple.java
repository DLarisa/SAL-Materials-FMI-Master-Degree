package com.java.proiect.dto;

import javax.validation.constraints.*;

import static com.java.proiect.model.Patterns.YEAR_VALIDATION;

public class UpdateGroupDtoToGroupSimple {
    @NotNull(message = "You must provide an id for the group!")
    private int id;

    @NotBlank(message = "A group must have a name!")
    @Size(max = 300)
    private String name;

    @NotNull(message = "The year of debut must be mentioned!")
    @Pattern(regexp = YEAR_VALIDATION, message = "Year must be between 2000 - 2099")
    @Min(2000)
    private String yearDebut;

    @Pattern(regexp = YEAR_VALIDATION, message = "Year must be between 2000 - 2099 or null, if nonexistent")
    private String yearDisbandment;



    public UpdateGroupDtoToGroupSimple() {
    }

    public UpdateGroupDtoToGroupSimple(String name, String yearDebut, String yearDisbandment) {
        this.name = name;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public UpdateGroupDtoToGroupSimple(int id, String name, String yearDebut, String yearDisbandment) {
        this.id = id;
        this.name = name;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getYearDebut() {
        return yearDebut;
    }

    public void setYearDebut(String yearDebut) {
        this.yearDebut = yearDebut;
    }

    public String getYearDisbandment() {
        return yearDisbandment;
    }

    public void setYearDisbandment(String yearDisbandment) {
        this.yearDisbandment = yearDisbandment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
