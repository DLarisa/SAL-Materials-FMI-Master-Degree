package hibernate.ex.model;

import javax.persistence.*;

/*
    Un album poate să aibă o singură clasă de detalii.
    O clasă de detalii aparține unui singur album.
    One-to-One
 */
@Entity // e o tabelă
@Table(name = "album_details") // nu tb neapărat, dar poți numi tu altfel tabela decât ar fi ea numită automat
public class AlbumDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // tb și asta ca să spunem cum incrementează Id-ul; aici +1
    private int albumDetailsId;
    @Column(name = "description") // nu tb neapărat, dar poți numi tu altfel tabela decât ar fi ea numită automat
    private String description;

    public AlbumDetails() {
    }

    public AlbumDetails(String description) {
        this.description = description;
    }

    public AlbumDetails(int albumDetailsId, String description) {
        this.albumDetailsId = albumDetailsId;
        this.description = description;
    }

    public int getAlbumDetailsId() {
        return albumDetailsId;
    }

    public void setAlbumDetailsId(int albumDetailsId) {
        this.albumDetailsId = albumDetailsId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
