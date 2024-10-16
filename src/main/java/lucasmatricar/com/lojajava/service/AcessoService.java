package lucasmatricar.com.lojajava.service;

import lucasmatricar.com.lojajava.model.Acesso;
import lucasmatricar.com.lojajava.repository.AcessoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AcessoService {

    @Autowired
    private AcessoRepository acessoRepository;

    public Acesso save(Acesso acesso) {
        return acessoRepository.save(acesso);
    }
}
