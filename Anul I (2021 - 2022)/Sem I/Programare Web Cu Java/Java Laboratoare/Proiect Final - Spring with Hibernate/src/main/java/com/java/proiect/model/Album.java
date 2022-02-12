package com.java.proiect.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.java.proiect.dto.SongDtoForAlbum;
import com.java.proiect.mapper.SongMapper;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "albums")
public class Album {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "album_id")
    private int albumId;

    @Column(nullable = false)
    private String title;

    @Column(name = "year")
    private String year;

    @Column(name = "no_tracks")
    private int noTracks;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "group_id")
    private Group group;

    @OneToOne
    @JoinColumn(name = "album_details_id")
    private AlbumDetails albumDetails;

    @OneToMany(mappedBy = "album", cascade = CascadeType.ALL)
    private List<Song> songs = new ArrayList<>();



    public Album() {
    }

    public Album(int albumId, String title, String year, int noTracks, Group group, AlbumDetails albumDetails, List<Song> songs) {
        this.albumId = albumId;
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
        this.group = group;
        this.albumDetails = albumDetails;
        this.songs = songs;
    }

    public Album(int albumId, String title, String year, int noTracks) {
        this.albumId = albumId;
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
    }

    public Album(String title, String year, int noTracks) {
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
    }

    public Album(String title, String year, int noTracks, Group group, AlbumDetails albumDetails, List<SongDtoForAlbum> songs) {
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
        this.group = group;
        this.albumDetails = albumDetails;
        SongMapper songMapper = new SongMapper();
        List<Song> songs1 = new ArrayList<>();
        for(SongDtoForAlbum s: songs) {
            songs1.add(songMapper.createSongDtoToSongFromAlbum(s));
        }
        this.songs = songs1;
    }

    public Album(String title, String year, int noTracks, Group group, AlbumDetails albumDetails) {
        this.title = title;
        this.year = year;
        this.noTracks = noTracks;
        this.group = group;
        this.albumDetails = albumDetails;
    }

    public int getAlbumId() {
        return albumId;
    }

    public void setAlbumId(int albumId) {
        this.albumId = albumId;
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

    public Group getGroup() {
        return group;
    }

    public void setGroup(Group group) {
        this.group = group;
    }

    public AlbumDetails getAlbumDetails() {
        return albumDetails;
    }

    public void setAlbumDetails(AlbumDetails albumDetails) {
        this.albumDetails = albumDetails;
    }

    public List<Song> getSongs() {
        return songs;
    }

    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }
}
