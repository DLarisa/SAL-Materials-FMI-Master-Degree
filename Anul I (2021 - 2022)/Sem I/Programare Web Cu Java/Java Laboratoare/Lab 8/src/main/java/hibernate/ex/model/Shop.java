package hibernate.ex.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

/*
    Un album poate fi în mai multe magazine.
    Un magazin poate avea mai multe albume.
    Many-to-Many
 */
@Entity
public class Shop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int shopId;
    private String location;

    @ManyToMany // deobicei, lumea folosește OneToMany; gen, sparge relația; pt că e mai greu de operat cu M-M
    @JoinTable(name = "shop_album", joinColumns = @JoinColumn(name = "shop_id"),
               inverseJoinColumns = @JoinColumn(name = "album_id"))
    // nume tabelă, cheia principală de la tabela în care suntem și cheia principală (numită invers) de la cealaltă tabelă
    private List<Album> albumList = new ArrayList<>();

    public Shop() {
    }

    public Shop(String location) {
        this.location = location;
    }

    public int getShopId() {
        return shopId;
    }

    public void setShopId(int shopId) {
        this.shopId = shopId;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public List<Album> getAlbumList() {
        return albumList;
    }

    public void setAlbumList(List<Album> albumList) {
        this.albumList = albumList;
    }
}
