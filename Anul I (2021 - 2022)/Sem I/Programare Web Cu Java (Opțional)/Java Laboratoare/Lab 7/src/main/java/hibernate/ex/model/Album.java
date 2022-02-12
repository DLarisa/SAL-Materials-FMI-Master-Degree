package hibernate.ex.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

/*
    Un album poate fi în mai multe magazine.
    Un magazin poate avea mai multe albume.
    Many-to-Many
    ==============================================
    Un artist poate să aibă mai multe albume.
    Un album aparține unui artist.
    One-to-Many
    ==============================================
    Un album poate să aibă o singură clasă de detalii.
    O clasă de detalii aparține unui singur album.
    One-to-One
 */
@Entity
public class Album {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int albumId;
    private String albumName;
    private int albumQuantity;

    @OneToOne
    @JoinColumn(name = "album_details_id") // numele coloanei de legătură dintre cele 2 tabele
    private AlbumDetails albumDetails;

    @ManyToOne
    @JoinColumn(name = "artist_id") // cheia străină
//    @JsonIgnore // ca să nu mai vină chestia ciclică în REST
    private Artist artist;

    @ManyToMany(mappedBy = "albumList")
    @JsonIgnore
    private List<Shop> shops = new ArrayList<>();

    public Album() {
    }

    public Album(String albumName, int albumQuantity) {
        this.albumName = albumName;
        this.albumQuantity = albumQuantity;
    }

    public int getAlbumId() {
        return albumId;
    }

    public void setAlbumId(int albumId) {
        this.albumId = albumId;
    }

    public String getAlbumName() {
        return albumName;
    }

    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }

    public int getAlbumQuantity() {
        return albumQuantity;
    }

    public void setAlbumQuantity(int albumQuantity) {
        this.albumQuantity = albumQuantity;
    }

    public AlbumDetails getAlbumDetails() {
        return albumDetails;
    }

    public void setAlbumDetails(AlbumDetails albumDetails) {
        this.albumDetails = albumDetails;
    }

    public Artist getArtist() {
        return artist;
    }

    public void setArtist(Artist artist) {
        this.artist = artist;
    }

    public List<Shop> getShops() {
        return shops;
    }

    public void setShops(List<Shop> shops) {
        this.shops = shops;
    }
}
