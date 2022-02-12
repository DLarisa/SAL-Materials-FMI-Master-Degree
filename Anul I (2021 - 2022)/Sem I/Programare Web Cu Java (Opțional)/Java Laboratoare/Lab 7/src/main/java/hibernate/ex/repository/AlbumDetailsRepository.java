package hibernate.ex.repository;

import hibernate.ex.model.AlbumDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

// JpaRepository are ca argumente tabela cu care lucrează și tipul de date care este primary key-ul (tb neapărat să fie cls wrapper)
@Repository // putem pune, dar nu e necesar, pt că deja știe că JpaRepository e deja Bean în context
public interface AlbumDetailsRepository extends JpaRepository<AlbumDetails, Integer> {
}
