package lucasmatricar.com.lojajava.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
@Component
public class JWTTokenAutenticacaoService {

    private static final long EXPIRATION_TIME = 86400000;

    private static final String SECRET_KEY = "matricar";

    private static final String TOKEN_PREFIX = "Bearer ";

    private static final String HEADER_STRING = "Authorization";

    /*Gera o token e da a resposta para o cliente o com JWT*/
    public void addAuthorization(HttpServletResponse response, String username) throws Exception {
        /*Montagem do token*/
        String jwt = Jwts.builder().setSubject(username)/*adiciona o Usuário*/
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))/*Tempo de expiração do token*/
                .signWith(SignatureAlgorithm.HS512, SECRET_KEY).compact();

        String token = TOKEN_PREFIX + " " + jwt ;

        /*Adiciona o token no header do response*/
        response.addHeader(HEADER_STRING, token);

        /*Usado para testar o token*/
        response.getWriter().write("{\"Authorization\":\"" + token + "\"}");
    }

    public String generateToken(String email, String password) {
        return null;
    }

    public boolean validateToken(String token) {
        return false;
    }
}
