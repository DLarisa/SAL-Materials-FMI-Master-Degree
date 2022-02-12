package com.java.proiect.dto;

import com.java.proiect.model.AlbumDetails;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.util.ArrayList;
import java.util.List;

import static com.java.proiect.model.Patterns.YEAR_VALIDATION;

public class CreateAlbumDto {
    @NotBlank(message = "An album must have a title!")
    @Size(max = 300)
    private String title;

    @Pattern(regexp = YEAR_VALIDATION, message = "Year must be between 2000 - 2099")
    @Min(2000)
    private String year;

    @Min(value = 0, message = "No of tracks must be positive!")
    private int noTracks;

    @NotBlank(message = "An album must belong to a group!")
    @Size(max = 300)
    private String groupName;

    private AlbumDetails albumDetails;
    private List<SongDtoForAlbum> songs = new ArrayList<>();



    public CreateAlbumDto() {
    }

    public CreateAlbumDto(String title, String year, int noTracks, String groupName, AlbumDetails albumDetails) {
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
        this.groupName = groupName;
        this.albumDetails = albumDetails;
    }

    public CreateAlbumDto(String title, String year, int noTracks, String groupName, AlbumDetails albumDetails, List<SongDtoForAlbum> songs) {
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
        this.groupName = groupName;
        this.albumDetails = albumDetails;
        this.songs = songs;
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

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public AlbumDetails getAlbumDetails() {
        return albumDetails;
    }

    public void setAlbumDetails(AlbumDetails albumDetails) {
        this.albumDetails = albumDetails;
    }

    public List<SongDtoForAlbum> getSongs() {
        return songs;
    }

    public void setSongs(List<SongDtoForAlbum> songs) {
        this.songs = songs;
    }
}
