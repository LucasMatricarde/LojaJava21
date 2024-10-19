package lucasmatricar.com.lojajava;

import com.fasterxml.jackson.databind.ObjectMapper;
import lucasmatricar.com.lojajava.controller.AcessoController;
import lucasmatricar.com.lojajava.model.Acesso;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
public class LojaJavaApplicationTests {

	@Autowired
	private MockMvc mockMvc;

	@Autowired
	private AcessoController acessoController;

	@Test
	public void testRestApiCadastraAcesso() throws Exception {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_COMPRADOR");

		ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post("/saveAcesso")
				.contentType(MediaType.APPLICATION_JSON)
				.content(new ObjectMapper().writeValueAsString(acesso))
				.accept(MediaType.APPLICATION_JSON));

		resultActions.andExpect(status().isOk());
	}

	@Test
	public void testeCadastraAcesso() {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_ADMIN");

		acesso = acessoController.saveAcesso(acesso).getBody();

		assert acesso != null;
		assert acesso.getId() > 0;
	}
}