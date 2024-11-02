package lucasmatricar.com.lojajava.controller;

import lucasmatricar.com.lojajava.model.Acesso;
import lucasmatricar.com.lojajava.repository.AcessoRepository;
import lucasmatricar.com.lojajava.service.AcessoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RestController
public class AcessoController {

    @Autowired
    private AcessoService acessoService;

    @Autowired
    private AcessoRepository acessoRepository;

    @ResponseBody //retorna o objeto como JSON
    @PostMapping(value = "/saveAcesso") //mapeia a URL para o metodo
    public ResponseEntity<Acesso> saveAcesso(@RequestBody Acesso acesso) {
        Acesso acessoSaved = acessoService.save(acesso);

        return new ResponseEntity<Acesso>(acessoSaved, HttpStatus.OK);
    }

    @ResponseBody //retorna o objeto como JSON
    @PostMapping(value = "/deleteAcesso") //mapeia a URL para o metodo
    public ResponseEntity<?> deleteAcesso(@RequestBody Acesso acesso) {
        acessoRepository.deleteById(acesso.getId());

        return new ResponseEntity("Acesso deletado com sucesso", HttpStatus.OK);
    }
}
