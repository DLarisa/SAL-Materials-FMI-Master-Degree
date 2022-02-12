package hibernate.ex;

import hibernate.ex.model.Album;
import hibernate.ex.model.AlbumDetails;
import hibernate.ex.model.Artist;
import hibernate.ex.model.Shop;
import hibernate.ex.repository.AlbumDetailsRepository;
import hibernate.ex.repository.AlbumRepository;
import hibernate.ex.repository.ArtistRepository;
import hibernate.ex.repository.ShopRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Arrays;

@SpringBootApplication
// implementăm să adăugăm chestii în tabele de mână cu CommandLineRunner
public class ExApplication implements CommandLineRunner {
    /*
        JPA -> Java Persistence API
        JPQL -> Java Persistence Query Language (putem folosi și query vechi, dar asta e mai "inteligent")
        ===================================================================================================
        @OneToOne; @OneToMany; @ManyToOne; @ManyToMany

        Relațiile: unidirecționale (doar una dintre entități știe de relație); bidirecționale (ambele entități)
     */
    private final AlbumDetailsRepository albumDetailsRepository;
    private final AlbumRepository albumRepository;
    private final ArtistRepository artistRepository;
    private final ShopRepository shopRepository;

    public ExApplication(AlbumDetailsRepository albumDetailsRepository, AlbumRepository albumRepository, ArtistRepository artistRepository, ShopRepository shopRepository) {
        this.albumDetailsRepository = albumDetailsRepository;
        this.albumRepository = albumRepository;
        this.artistRepository = artistRepository;
        this.shopRepository = shopRepository;
    }

    public static void main(String[] args) {
        SpringApplication.run(ExApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        Artist artist1 = new Artist("Artist 1");
        Artist artist2 = new Artist("Artist 2");
        artistRepository.save(artist1); artistRepository.save(artist2);

        AlbumDetails albumDetails1 = new AlbumDetails("Description Album 1");
        AlbumDetails albumDetails2 = new AlbumDetails("Description Album 2");
        albumDetailsRepository.save(albumDetails1); albumDetailsRepository.save(albumDetails2);

        Album album1 = new Album("Album 1", 5);
        Album album2 = new Album("Album 2", 6);
        album1.setAlbumDetails(albumDetails1);
        album2.setAlbumDetails(albumDetails2);
        album1.setArtist(artist1);
        album2.setArtist(artist2);
        albumRepository.save(album1); albumRepository.save(album2);

        Shop shop = new Shop("București");
        shop.setAlbumList(Arrays.asList(album1, album2));
        shopRepository.save(shop);
    }
}
