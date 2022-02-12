package com.java.proiect.service;

import com.java.proiect.model.Artist;
import com.java.proiect.model.Languages;
import com.java.proiect.model.Song;
import com.java.proiect.repository.AlbumRepository;
import com.java.proiect.repository.GenreRepository;
import com.java.proiect.repository.SongRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class SongServiceTest {
    @InjectMocks
    private SongService songService;

    @Mock
    private SongRepository songRepository;
    @Mock
    private AlbumRepository albumRepository;
    @Mock
    private GenreRepository genreRepository;

    @Test
    @DisplayName("Song created successfully")
    void add() {
        Song song = new Song("Forever", "4m 58s", Languages.ENGLISH);
        Song savedSong = new Song(1, "Forever", "4m 58s", Languages.ENGLISH);
        when(songRepository.save(song)).thenReturn(savedSong);

        Song result = songService.add(song);

        assertNotNull(result);
        assertEquals(savedSong.getSongId(), result.getSongId());
        assertEquals(savedSong.getTitle(), result.getTitle());
        assertEquals(savedSong.getLength(), result.getLength());
        assertEquals(savedSong.getLanguage(), result.getLanguage());

        verify(songRepository).save(song);
    }
}
