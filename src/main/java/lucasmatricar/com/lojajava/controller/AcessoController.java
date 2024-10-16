package lucasmatricar.com.lojajava.controller;

import lucasmatricar.com.lojajava.model.Acesso;
import lucasmatricar.com.lojajava.service.AcessoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AcessoController {

    @Autowired
    private AcessoService acessoService;

    @PostMapping("/saveAcesso")
    public Acesso saveAcesso(Acesso acesso) {
        return acessoService.save(acesso);
    }
}
