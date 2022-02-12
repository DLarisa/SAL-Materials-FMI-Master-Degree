package com.java.proiect.dto;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

public class UpdateGroupDtoToGroupArtists {
    @NotNull(message = "You must provide an id for the group!")
    private int id;

    @NotNull(message = "A group must have at least one member!")
    @Min(1)
    private int noMembers;

    private List<ArtistDtoForGroup> artists = new ArrayList<>();



    public UpdateGroupDtoToGroupArtists() {
    }

    public UpdateGroupDtoToGroupArtists(int id, int noMembers, List<ArtistDtoForGroup> artists) {
        this.id = id;
        this.noMembers = noMembers;
        this.artists = artists;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNoMembers() {
        return noMembers;
    }

    public void setNoMembers(int noMembers) {
        this.noMembers = noMembers;
    }

    public List<ArtistDtoForGroup> getArtists() {
        return artists;
    }

    public void setArtists(List<ArtistDtoForGroup> artists) {
        this.artists = artists;
    }
}
