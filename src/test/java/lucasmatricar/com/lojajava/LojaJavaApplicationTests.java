package lucasmatricar.com.lojajava;

import junit.framework.TestCase;
import lucasmatricar.com.lojajava.controller.AcessoController;
import lucasmatricar.com.lojajava.model.Acesso;
import lucasmatricar.com.lojajava.repository.AcessoRepository;
import lucasmatricar.com.lojajava.service.AcessoService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = LojaJavaApplication.class)
public class LojaJavaApplicationTests extends TestCase {

	@Autowired
	private AcessoController acessoController;

	@Test
	public void testeCadastraAcesso() {
		Acesso acesso = new Acesso();

		acesso.setDescricao("ROLE_ADMIN");

		acesso = acessoController.saveAcesso(acesso).getBody();

        assertTrue(acesso.getId() > 0);
	}
}
