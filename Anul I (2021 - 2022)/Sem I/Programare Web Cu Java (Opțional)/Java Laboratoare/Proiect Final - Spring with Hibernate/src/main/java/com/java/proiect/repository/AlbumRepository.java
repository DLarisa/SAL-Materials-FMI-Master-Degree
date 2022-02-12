package com.java.proiect.repository;

import com.java.proiect.model.Album;
import com.java.proiect.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AlbumRepository extends JpaRepository<Album, Integer> {
    Optional<Album> findByTitleAndGroup(String title, Group group);
    List<Album> findByYear(String year);
    List<Album> findByAlbumDetails_Price(double price);
}
