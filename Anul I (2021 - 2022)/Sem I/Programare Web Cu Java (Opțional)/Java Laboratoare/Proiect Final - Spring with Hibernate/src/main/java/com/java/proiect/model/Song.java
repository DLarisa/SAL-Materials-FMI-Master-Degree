package com.java.proiect.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "songs")
public class Song {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "song_id")
    private int songId;

    @Column(nullable = false)
    private String title;

    private String length;
    private Languages language;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "album_id")
    private Album album;

    @ManyToMany()
    @JoinTable(name = "songs_genres",
               joinColumns = @JoinColumn(name = "song_id"),
               inverseJoinColumns = @JoinColumn(name = "genre_id"))
    private List<Genre> genres = new ArrayList<>();



    public Song() {
    }

    public Song(int songId, String title, String length, Languages language, Album album, List<Genre> genres) {
        this.songId = songId;
        this.title = title;
        this.length = length;
        this.language = language;
        this.album = album;
        this.genres = genres;
    }

    public Song(int songId, String title, String length, Languages language) {
        this.songId = songId;
        this.title = title;
        this.length = length;
        this.language = language;
    }

    public Song(String title, String length, Languages language, Album album, List<Genre> genres) {
        this.title = title;
        this.length = length;
        this.language = language;
        this.album = album;
        this.genres = genres;
    }

    public Song(String title, String length, Languages language) {
        this.title = title;
        this.length = length;
        this.language = language;
    }

    public int getSongId() {
        return songId;
    }

    public void setSongId(int songId) {
        this.songId = songId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public Languages getLanguage() {
        return language;
    }

    public void setLanguage(Languages language) {
        this.language = language;
    }

    public Album getAlbum() {
        return album;
    }

    public void setAlbum(Album album) {
        this.album = album;
    }

    public List<Genre> getGenres() {
        return genres;
    }

    public void setGenres(List<Genre> genres) {
        this.genres = genres;
    }
}
