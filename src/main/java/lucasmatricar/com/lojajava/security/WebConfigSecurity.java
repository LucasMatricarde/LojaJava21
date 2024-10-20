package lucasmatricar.com.lojajava.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class WebConfigSecurity {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(HttpMethod.GET, "/saveAcesso").permitAll()
                        .requestMatchers(HttpMethod.POST, "/saveAcesso").permitAll()
                        .requestMatchers(HttpMethod.POST, "/deleteAcesso").permitAll())
                .csrf().disable(); // Desabilitar CSRF se necessário, ajuste conforme a lógica da sua aplicação

        return http.build();
    }
}
