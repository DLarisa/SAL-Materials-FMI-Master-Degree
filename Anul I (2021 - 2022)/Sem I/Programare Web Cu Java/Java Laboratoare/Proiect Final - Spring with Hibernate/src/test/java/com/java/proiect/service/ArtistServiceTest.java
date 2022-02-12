package com.java.proiect.service;

import com.java.proiect.exceptions.DuplicateArtistStageNameError;
import com.java.proiect.model.Artist;
import com.java.proiect.model.Group;
import com.java.proiect.repository.ArtistRepository;
import com.java.proiect.repository.GroupRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ArtistServiceTest {
    @InjectMocks
    private ArtistService artistService;

    @Mock
    private ArtistRepository artistRepository;
    @Mock
    private GroupRepository groupRepository;

    @Test
    @DisplayName("Artist created successfully")
    void add() {
        Artist artist = new Artist("Mark", "Lee", "Mark", "02-Aug-1999");
        when(artistRepository.findByStageName(artist.getStageName())).thenReturn(Optional.empty());
        Artist savedArtist = new Artist(1, "Mark", "Lee", "Mark", "02-Aug-1999");
        when(artistRepository.save(artist)).thenReturn(savedArtist);

        Artist result = artistService.add(artist);

        assertNotNull(result);
        assertEquals(savedArtist.getArtistId(), result.getArtistId());
        assertEquals(savedArtist.getFirstName(), result.getFirstName());
        assertEquals(savedArtist.getLastName(), result.getLastName());
        assertEquals(savedArtist.getStageName(), result.getStageName());
        assertEquals(savedArtist.getDateBirth(), result.getDateBirth());

        verify(artistRepository).findByStageName(artist.getStageName());
        verify(artistRepository).save(artist);
    }

    @Test
    @DisplayName("Artist NOT created - Duplicate Stage Name")
    void addThrowsError() {
        Artist artist = new Artist("Mark", "Lee", "Mark", "02-Aug-1999");
        when(artistRepository.findByStageName(artist.getStageName())).thenReturn(Optional.of(artist));

        DuplicateArtistStageNameError error = assertThrows(DuplicateArtistStageNameError.class,
                () -> artistService.add(artist));

        assertNotNull(error);
        assertEquals("There is already an artist with the stage name: " + artist.getStageName(),
                error.getMessage());

        verify(artistRepository).findByStageName(artist.getStageName());
    }

    @Test
    @DisplayName("Artist stageName cannot be updated - new stageName belongs to other artist")
    void updateStageNameException() {
        //arrange
        Artist oldArtist = new Artist(1, "Mark", "Lee", "Mark", "02-Aug-1999");
        Artist newArtist = new Artist(1, "Mark", "Lee", "Mark1", "02-Aug-1999");
        Artist anotherArtist = new Artist(2, "Mark1", "Lee1", "Mark1", "03-Aug-1999");
        when(artistRepository.findById(newArtist.getArtistId()))
                .thenReturn(Optional.of(oldArtist));
        when(artistRepository.findByStageName(newArtist.getStageName()))
                .thenReturn(Optional.of(anotherArtist));

        //act
        DuplicateArtistStageNameError exception = assertThrows(DuplicateArtistStageNameError.class,
                () -> artistService.update(newArtist));

        //assert
        assertNotNull(exception);
        assertEquals("There is already an artist with the stage name: " + newArtist.getStageName(),
                exception.getMessage());

        verify(artistRepository).findById(newArtist.getArtistId());
        verify(artistRepository).findByStageName(newArtist.getStageName());
        verify(artistRepository, times(0)).save(newArtist);
    }

    @Test
    @DisplayName("Get all artists")
    void get() {
        Artist artist = new Artist(1, "Mark", "Lee", "Mark", "02-Aug-1999");
        when(artistRepository.findAll()).thenReturn(List.of(artist));

        List<Artist> result = artistService.get();

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(artist, result.get(0));

        verify(artistRepository, never()).findByStageName((any()));
        verify(artistRepository).findAll();
    }

    //    @Test
//    @DisplayName("Artist update successfully")
//    void update() {
//        Group group = new Group();
//        Artist artistOld = new Artist(1, "Mark", "Lee", "Mark", "02-Aug-1999", group);
//        Artist artistNew = new Artist(1, "Mark1", "Lee", "Mark", "03-Aug-1999", group);
//        when(artistRepository.findById(artistNew.getArtistId())).thenReturn(Optional.of(artistOld));
//        when(artistRepository.save(artistNew)).thenReturn(artistNew);
//
//        Artist result = artistService.update(artistNew);
//
//        assertNotNull(result);
//        assertEquals(artistNew.getArtistId(), result.getArtistId());
//        assertEquals(artistNew.getFirstName(), result.getFirstName());
//        assertEquals(artistNew.getLastName(), result.getLastName());
//        assertEquals(artistNew.getStageName(), result.getStageName());
//        assertEquals(artistNew.getDateBirth(), result.getDateBirth());
//
//        verify(artistRepository).findById(artistNew.getArtistId());
//    }
}
