package com.java.proiect.dto;

import javax.validation.constraints.*;

import static com.java.proiect.model.Patterns.YEAR_VALIDATION;

public class UpdateAlbumDtoSimple {
    @NotNull(message = "You must provide id for the album!")
    private int id;

    @NotBlank(message = "An album must have a title!")
    @Size(max = 300)
    private String title;

    @Pattern(regexp = YEAR_VALIDATION, message = "Year must be between 2000 - 2099")
    @Min(2000)
    private String year;

    @Min(value = 0, message = "No of tracks must be positive!")
    private int noTracks;



    public UpdateAlbumDtoSimple() {
    }

    public UpdateAlbumDtoSimple(int id, String title, String year, int noTracks) {
        this.id = id;
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public int getNoTracks() {
        return noTracks;
    }

    public void setNoTracks(int noTracks) {
        this.noTracks = noTracks;
    }
}
