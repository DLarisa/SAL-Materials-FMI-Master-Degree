package com.java.proiect.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import javax.validation.constraints.Min;

@Entity
@Table(name = "albums_details")
public class AlbumDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "album_details_id")
    private int albumDetailsId;

    @Min(value = 0, message = "Price must be positive!")
    private double price;
    @Min(value = 0, message = "Quantity must be positive!")
    private int quantity;

    @OneToOne(mappedBy = "albumDetails", cascade = CascadeType.ALL)
    @JsonIgnore
    private Album album;



    public AlbumDetails() {
    }

    public AlbumDetails(int albumDetailsId, double price, int quantity) {
        this.albumDetailsId = albumDetailsId;
        this.price = price;
        this.quantity = quantity;
    }

    public AlbumDetails(double price, int quantity) {
        this.price = price;
        this.quantity = quantity;
    }

    public int getAlbumDetailsId() {
        return albumDetailsId;
    }

    public void setAlbumDetailsId(int albumDetailsId) {
        this.albumDetailsId = albumDetailsId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Album getAlbum() {
        return album;
    }

    public void setAlbum(Album album) {
        this.album = album;
    }
}
