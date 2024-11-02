package lucasmatricar.com.lojajava.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lucasmatricar.com.lojajava.ApplicationContextLoad;
import lucasmatricar.com.lojajava.model.Usuario;
import lucasmatricar.com.lojajava.repository.UsuarioRepository;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;

@Service
@Component
public class JWTTokenAutenticacaoService {

    private static final long EXPIRATION_TIME = 86400000;

    private static final String SECRET_KEY = "adsdssad=asdsa--sadaca-1";

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

        liberacaoCors(response);

        /*Usado para testar o token*/
        response.getWriter().write("{\"Authorization\":\"" + token + "\"}");
    }

    public Authentication getAuthentication(HttpServletRequest request, HttpServletResponse response) {
        String token = request.getHeader(HEADER_STRING);

        if(token != null) {
            String cleanToken = token.replace(TOKEN_PREFIX, "").trim();
            String user = Jwts.parser()
                    .setSigningKey(SECRET_KEY).build()
                    .parseClaimsJws(cleanToken)
                    .getBody().getSubject();

            if(user != null) {
                Usuario usuario = ApplicationContextLoad.getApplicationContext().getBean(UsuarioRepository.class).findByLogin(user);

                if(usuario != null) {
                    return new UsernamePasswordAuthenticationToken(usuario.getLogin(), usuario.getSenha(), usuario.getAuthorities());
                }
            }
        }

        liberacaoCors(response);
        return null;
    }

    private void liberacaoCors(HttpServletResponse response) {
        if(response.getHeader("Access-Control-Allow-Origin") == null) {
            response.addHeader("Access-Control-Allow-Origin", "*");
        }

        if(response.getHeader("Access-Control-Allow-Methods") == null) {
            response.addHeader("Access-Control-Allow-Methods", "*");
        }

        if(response.getHeader("Access-Control-Request-Headers") == null) {
            response.addHeader("Access-Control-Request-Headers", "*");
        }

        if(response.getHeader("Access-Control-Allow-Headers") == null) {
            response.addHeader("Access-Control-Allow-Headers", "*");
        }
    }
}
