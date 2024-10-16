package lucasmatricar.com.lojajava;

import lucasmatricar.com.lojajava.model.Acesso;
import lucasmatricar.com.lojajava.repository.AcessoRepository;
import lucasmatricar.com.lojajava.service.AcessoService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = LojaJavaApplication.class)
public class LojaJavaApplicationTests {

	@Autowired
	private AcessoService acessoService;

	@Test
	public void testeCadastraAcesso() {
		Acesso acesso = new Acesso();

		acesso.setDescricao("ROLE_ADMIN");

		acessoService.save(acesso);
	}

}
