package com.java.proiect.repository;

import com.java.proiect.model.AlbumDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AlbumDetailsRepository extends JpaRepository<AlbumDetails, Integer> {
}
