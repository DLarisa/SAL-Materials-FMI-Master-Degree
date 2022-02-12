package com.java.proiect.dto;

import javax.validation.constraints.NotNull;

public class UpdateArtistDto extends ArtistDtoForGroup{
    @NotNull(message = "You must provide an id for the artist!")
    private int id;



    public UpdateArtistDto() {
    }

    public UpdateArtistDto(String firstName, String lastName, String stageName, String dateBirth, int id) {
        super(firstName, lastName, stageName, dateBirth);
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
