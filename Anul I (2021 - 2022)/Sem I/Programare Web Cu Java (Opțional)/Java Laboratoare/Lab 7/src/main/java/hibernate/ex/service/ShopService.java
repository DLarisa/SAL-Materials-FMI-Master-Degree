package hibernate.ex.service;

import hibernate.ex.model.Album;
import hibernate.ex.model.AlbumDetails;
import hibernate.ex.model.Artist;
import hibernate.ex.model.Shop;
import hibernate.ex.repository.AlbumDetailsRepository;
import hibernate.ex.repository.AlbumRepository;
import hibernate.ex.repository.ArtistRepository;
import hibernate.ex.repository.ShopRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Service
public class ShopService {

    private final AlbumDetailsRepository albumDetailsRepository;
    private final AlbumRepository albumRepository;
    private final ArtistRepository artistRepository;
    private final ShopRepository shopRepository;

    @Autowired
    public ShopService(AlbumDetailsRepository albumDetailsRepository, AlbumRepository albumRepository, ArtistRepository artistRepository, ShopRepository shopRepository) {
        this.albumDetailsRepository = albumDetailsRepository;
        this.albumRepository = albumRepository;
        this.artistRepository = artistRepository;
        this.shopRepository = shopRepository;
    }

    public Artist saveNewArtist(Artist artist) {
        return artistRepository.save(artist);
    }

    public AlbumDetails saveAlbumDetails(AlbumDetails albumDetails) {
        return albumDetailsRepository.save(albumDetails);
    }

    public Album saveAlbum(Album album, int albumDetailsId, int artistId) {
        AlbumDetails albumDetails = albumDetailsRepository.findById(albumDetailsId).
                orElseThrow(() -> new RuntimeException("Id of album is not a valid one!"));
        Artist artist = artistRepository.findById(artistId).
                orElseThrow(() -> new RuntimeException("Id of artist is not a valid one!"));

        album.setAlbumDetails(albumDetails);
        album.setArtist(artist);
        return albumRepository.save(album);
    }

    public Shop saveShop(Shop shop, List<Integer> albumIds) {
        List<Album> albums = albumRepository.findAllById(albumIds);
        shop.setAlbumList(albums);
        return shopRepository.save(shop);
    }

    public List<Shop> retrieveShops() {
        return shopRepository.findAll();
    }

    public Album retrieveAlbumByName(String albumName) {
        return albumRepository.findAlbumByAlbumName(albumName);
        // return albumRepository.findAlbumsByAlbumNameWithJpql(albumName);
        // return albumRepository.findAlbumByAlbumNameWithNativeQuery(albumName);
    }

    @Transactional // adică dacă le bușește, să revină la starea inițială
    // gândește-te la bancomat: dacă se bușește tranzacția, nu vrei să îți ia banii
    /*
        Tranzacții sunt caracterizate de cuvântul ACID:
        Atomic, Consistency, Isolated, Durable
     */
    public String bulkLoadArtist() {
        for(int i = 10; i < 20; i++) {
            if(i == 15) {
                throw new RuntimeException("Some error has occured on i = 15");
            }

            Artist artist = new Artist("Artist " + i);
            artistRepository.save(artist);
        }

        return "OK!";
    }
}
