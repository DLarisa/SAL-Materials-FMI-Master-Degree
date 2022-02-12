package hibernate.ex.service;

import hibernate.ex.model.Album;
import hibernate.ex.model.AlbumDetails;
import hibernate.ex.model.Artist;
import hibernate.ex.repository.AlbumDetailsRepository;
import hibernate.ex.repository.AlbumRepository;
import hibernate.ex.repository.ArtistRepository;
import hibernate.ex.repository.ShopRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class) // am marcat ca fiind clasă de test
public class ShopServiceTest {
    /*
        @InjectMocks -> folosim pe resursa pe care noi vrem să scriem testul unitar (ShopService, aici)
        @Mock -> pt a da comportamente celorlalte resurse din clasa noastră inițială (adică, variabilele din cls inițială sunt Mock-uri)
        ========================================
        @BeforeEach; @AfterEach; @BeforeAll; @AfterAll -> în special la testele de integrare
        Spre ex: vreau să verific dacă există conexiunea la baza de date
     */

    @InjectMocks
    private ShopService shopService;

    @Mock
    private AlbumDetailsRepository albumDetailsRepository;
    @Mock
    private AlbumRepository albumRepository;
    @Mock
    private ArtistRepository artistRepository;
    @Mock
    private ShopRepository shopRepository;

    @Test
    @DisplayName("Running save Artist in a happy flow.") //ca să numesc diferit, în consolă, testul (să fie mai sugestiv) -> nu e neapărat necesar
    // toate testele sunt cu void
    void saveNewArtistHappyFlow() {
        // Trebuie respectată ordinea, pt că altfel se bușește

        // Arrange -> definim comportamentul pentru mock-urile noastre (ce vrem să facă mock-urile)
        Artist artist1 = new Artist("Artist Test 1");
//        Artist artist2 = new Artist("Artist Test 2");
        when(artistRepository.save(artist1)).thenReturn(artist1); //pot să mai adaug .thenReturn în continuare (fiecare thenReturn va fi asociat pt fiecare funcție pe care vrem să o testăm)

        // Act -> apelul propriu-zis (call the inject mock method)
        Artist result = shopService.saveNewArtist(artist1);

        // Assert -> ce vrea să verific (check the result based on arrange and act)
        assertEquals(artist1.getArtistName(), result.getArtistName());
    }

    @Test
    @DisplayName("Running save album details in a happy flow")
    void saveNewAlbumDetailsHappyFlow() {
        AlbumDetails albumDetails = new AlbumDetails("Album Details 1");
        when(albumDetailsRepository.save(albumDetails)).thenReturn(albumDetails);

        AlbumDetails result = shopService.saveAlbumDetails(albumDetails);

        assertEquals(albumDetails.getDescription(), result.getDescription());
        assertNotNull(result);
    }

    @Test
    @DisplayName("Bulk load test negative flow")
    void bulkLoadTestNegativeFlow() {
        // arrange
        int n = 17;
        String response = "Some error has occured on i = 15";

        // act
        RuntimeException result = assertThrows(
                RuntimeException.class,
                () -> shopService.bulkLoadArtist(n));

        // assert
        assertEquals(response, result.getMessage());
    }

    @Test
    @DisplayName("Save album using negative flow")
    void saveAlbumTestNegativeFlow() {
        // arrange
        int albumDetailsId = 1;
        int artistId = 2;
        int albumQuantity = 5;

        AlbumDetails albumDetails = new AlbumDetails("TestAlbumDetails");
        Artist artist = new Artist("TestArtist");
        Album album = new Album("TestAlbum", albumQuantity);

        when(albumDetailsRepository.findById(albumDetailsId)).thenThrow(new RuntimeException("Some exception has occurred"));
//        when(artistRepository.findById(artistId)).thenReturn(Optional.of(artist));
//        when(albumRepository.save(album)).thenReturn(album);

        // act
        try {
            Album result = shopService.saveAlbum(album, albumDetailsId, artistId);
        } catch (RuntimeException e) {
            assertEquals("Some exception has occurred", e.getMessage());
            verify(artistRepository, times(0)).findById(artistId);
            verify(albumDetailsRepository, times(1)).findById(albumDetailsId);
        }

        // assert
//        assertEquals(album.getAlbumQuantity(), 5);
//        assertEquals(album.getAlbumName(), result.getAlbumName());
//        assertEquals(artist.getArtistName(), result.getArtist().getArtistName());
//        assertEquals(albumDetails.getDescription(), result.getAlbumDetails().getDescription());
    }
}
