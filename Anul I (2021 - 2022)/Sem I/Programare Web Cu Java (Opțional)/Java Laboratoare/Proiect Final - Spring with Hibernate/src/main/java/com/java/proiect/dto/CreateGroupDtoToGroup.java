package com.java.proiect.dto;

import javax.validation.constraints.*;

import java.util.ArrayList;
import java.util.List;

import static com.java.proiect.model.Patterns.YEAR_VALIDATION;

public class CreateGroupDtoToGroup {
    @NotBlank(message = "A group must have a name!")
    @Size(max = 300)
    private String name;

    @NotNull(message = "A group must have at least one member!")
    @Min(1)
    private int noMembers;

    @NotNull(message = "The year of debut must be mentioned!")
    @Pattern(regexp = YEAR_VALIDATION, message = "Year must be between 2000 - 2099")
    @Min(2000)
    private String yearDebut;

    @Pattern(regexp = YEAR_VALIDATION, message = "Year must be between 2000 - 2099 or null, if nonexistent")
    private String yearDisbandment;

    private List<ArtistDtoForGroup> artists = new ArrayList<>();



    public CreateGroupDtoToGroup() {
    }

    public CreateGroupDtoToGroup(String name, int noMembers, String yearDebut, String yearDisbandment) {
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
    }

    public CreateGroupDtoToGroup(String name, int noMembers, String yearDebut, String yearDisbandment, List<ArtistDtoForGroup> artists) {
        this.name = name;
        this.noMembers = noMembers;
        this.yearDebut = yearDebut;
        this.yearDisbandment = yearDisbandment;
        this.artists = artists;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNoMembers() {
        return noMembers;
    }

    public void setNoMembers(int noMembers) {
        this.noMembers = noMembers;
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

    public List<ArtistDtoForGroup> getArtists() {
        return artists;
    }

    public void setArtists(List<ArtistDtoForGroup> artists) {
        this.artists = artists;
    }
}
