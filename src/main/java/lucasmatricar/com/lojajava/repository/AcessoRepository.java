package lucasmatricar.com.lojajava.repository;

import lucasmatricar.com.lojajava.model.Acesso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public interface AcessoRepository extends JpaRepository<Acesso, Long> {

    @Query("SELECT a FROM Acesso a WHERE upper(trim(a.descricao)) like %?1%")
    List<Acesso> findByDescricao(String descricao);
}
