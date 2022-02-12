package com.java.proiect.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "genres")
public class Genre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "genre_id")
    private int genreId;

    @Column(nullable = false, unique = true)
    private String type;

    @ManyToMany(mappedBy = "genres", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JsonIgnore
    private List<Song> songs = new ArrayList<>();



    public Genre() {
    }

    public Genre(int genreId, String type, List<Song> songs) {
        this.genreId = genreId;
        this.type = type;
        this.songs = songs;
    }

    public Genre(int genreId, String type) {
        this.genreId = genreId;
        this.type = type;
    }

    public Genre(String type, List<Song> songs) {
        this.type = type;
        this.songs = songs;
    }

    public Genre(String type) {
        this.type = type;
    }

    public int getGenreId() {
        return genreId;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<Song> getSongs() {
        return songs;
    }

    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }
}
