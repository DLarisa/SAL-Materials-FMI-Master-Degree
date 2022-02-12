package com.java.proiect.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import static com.java.proiect.model.Patterns.DATE_OF_BIRTH;

public class ArtistDtoForGroup {
    @NotBlank(message = "An artist must have a first name!")
    @Size(max = 300)
    private String firstName;

    @NotBlank(message = "An artist must have a last name!")
    @Size(max = 300)
    private String lastName;

    @NotBlank(message = "An artist must have a stage name!")
    @Size(max = 300)
    private String stageName;

    @NotBlank(message = "An artist must have a date of birth!")
    @Pattern(regexp = DATE_OF_BIRTH, message = "The format must be dd-mmm-yyyy, with year between 1970-2099!")
    private String dateBirth;



    public ArtistDtoForGroup() {
    }

    public ArtistDtoForGroup(String firstName, String lastName, String stageName, String dateBirth) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.stageName = stageName;
        this.dateBirth = dateBirth;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public String getDateBirth() {
        return dateBirth;
    }

    public void setDateBirth(String dateBirth) {
        this.dateBirth = dateBirth;
    }
}
