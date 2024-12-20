package lucasmatricar.com.lojajava.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lucasmatricar.com.lojajava.model.Usuario;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

import java.io.IOException;

public class JWTLoginFilter extends AbstractAuthenticationProcessingFilter {
    /*Configurando o gerenciamento de autenticação*/
    public JWTLoginFilter(String url, AuthenticationManager authenticationManager) {

        /*Obriga a autenticar a url*/
        super(new AntPathRequestMatcher(url));

        /*Gerenciamento de autenticação*/
        setAuthenticationManager(authenticationManager);
    }

    protected JWTLoginFilter(RequestMatcher requiresAutenticationResquestMatcher) {
        super(requiresAutenticationResquestMatcher);
    }

    /*Retorna o usuario ao processar a autenticação*/
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException, IOException, ServletException {
        /*Obter o usuario*/
        Usuario user = new ObjectMapper().readValue(request.getInputStream(), Usuario.class);

        /*Retornar o user com login e senha*/
        return getAuthenticationManager().authenticate(new UsernamePasswordAuthenticationToken(user.getLogin(), user.getSenha()));
    }

    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) throws IOException, ServletException {
        try {
            new JWTTokenAutenticacaoService().addAuthorization(response, authResult.getName());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
