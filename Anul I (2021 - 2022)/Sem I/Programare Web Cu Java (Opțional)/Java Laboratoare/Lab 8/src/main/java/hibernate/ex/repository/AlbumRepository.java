package hibernate.ex.repository;

import hibernate.ex.model.Album;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AlbumRepository extends JpaRepository<Album, Integer> {
    Album findAlbumByAlbumName(String name);

    // sau
    @Query("select a from Album a where a.albumName = ?1") // adică ia primul parametru dat și înlocuiește semnul întrebării
    Album findAlbumsByAlbumNameWithJpql(String name);

    // sau
    @Query(value = "select * from album a where a.album_name = :name", nativeQuery = true)
    Album findAlbumByAlbumNameWithNativeQuery(String name);
}
