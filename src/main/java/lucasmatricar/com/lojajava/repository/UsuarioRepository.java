package lucasmatricar.com.lojajava.repository;

import lucasmatricar.com.lojajava.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long>{

    Usuario findByLogin(String login);
}
