package com.java.proiect.repository;

import com.java.proiect.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GroupRepository extends JpaRepository<Group, Integer> {
    Optional<Group> findByName(String name);

    @Query("select g from Group g where g.yearDebut=?1 or g.yearDisbandment=?1")
    List<Group> findByYear(String year);

    List<Group> findByNoMembers(int noMembers);

    @Query("select g from Group g where g.noMembers=?1 and (g.yearDebut=?2 or g.yearDisbandment=?2)")
    List<Group> findByNoMembersAndYear(int noMembers, String year);
}
