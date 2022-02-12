package com.java.proiect.service;

import com.java.proiect.exceptions.DuplicateArtistStageNameError;
import com.java.proiect.exceptions.DuplicateGroupError;
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

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class GroupServiceTest {
    @InjectMocks
    private GroupService groupService;

    @Mock
    private GroupRepository groupRepository;
    @Mock
    private ArtistRepository artistRepository;

    @Test
    @DisplayName("Group created successfully")
    void add() {
        Group group = new Group("aespa", 4, "2020", "2025");
        when(groupRepository.findByName(group.getName())).thenReturn(Optional.empty());
        Group savedGroup = new Group(1, "aespa", 4, "2020", "2025");
        when(groupRepository.save(group)).thenReturn(savedGroup);

        Group result = groupService.add(group);

        assertNotNull(result);
        assertEquals(savedGroup.getName(), result.getName());
        assertEquals(savedGroup.getNoMembers(), result.getNoMembers());
        assertEquals(savedGroup.getYearDebut(), result.getYearDebut());
        assertEquals(savedGroup.getYearDisbandment(), result.getYearDisbandment());

        verify(groupRepository).findByName(group.getName());
        verify(groupRepository).save(group);
    }

    @Test
    @DisplayName("Group NOT created - Duplicate Name")
    void addThrowsError() {
        Group group = new Group("aespa", 4, "2020", "2025");
        when(groupRepository.findByName(group.getName())).thenReturn(Optional.of(group));

        DuplicateGroupError error = assertThrows(DuplicateGroupError.class,
                () -> groupService.add(group));

        assertNotNull(error);
        assertEquals("There is already a group with the name: " + group.getName(),
                error.getMessage());
    }
}
