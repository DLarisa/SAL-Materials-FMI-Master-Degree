package com.java.proiect.repository;

import com.java.proiect.model.Languages;
import com.java.proiect.model.Song;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SongRepository extends JpaRepository<Song, Integer> {
    List<Song> findByLanguage(Languages l);
}
