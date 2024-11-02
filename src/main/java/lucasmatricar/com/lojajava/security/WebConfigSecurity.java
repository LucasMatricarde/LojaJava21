package lucasmatricar.com.lojajava.security;

import lucasmatricar.com.lojajava.service.ImplementsUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class WebConfigSecurity {

    @Autowired
    private ImplementsUserDetailsService implementsUserDetailsService;

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfiguration) throws Exception {
        return authConfiguration.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf
                        .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                        .disable()
                )
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers("/").permitAll()
                        .requestMatchers("/index", "/pagamento/**", "/resources/**", "/static/**", "/templates/**",
                                "classpath:/static/**", "classpath:/resources/**", "classpath:/templates/**").permitAll()
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .anyRequest().authenticated()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/index")
                );

        // Adiciona os filtros após a configuração básica
        http.addFilterAfter(jwtLoginFilter(authenticationManager(http.getSharedObject(AuthenticationConfiguration.class))),
                UsernamePasswordAuthenticationFilter.class)
            .addFilterBefore(new JwtApiAutenticacaoFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public JWTLoginFilter jwtLoginFilter(AuthenticationManager authenticationManager) throws Exception {
        return new JWTLoginFilter("/login", authenticationManager);
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return web -> web.ignoring()
                .requestMatchers(HttpMethod.GET, "/requisicaojunoboleto/**", "/notificacaoapiv2", "/pagamento/**",
                        "/resources/**", "/static/**", "/templates/**", "classpath:/static/**",
                        "classpath:/resources/**", "classpath:/templates/**", "/webjars/**",
                        "/WEB-INF/classes/static/**", "/recuperarSenha", "/criaAcesso")
                .requestMatchers(HttpMethod.POST, "/requisicaojunoboleto/**", "/notificacaoapiv2", "/pagamento/**",
                        "/resources/**", "/static/**", "/templates/**", "classpath:/static/**",
                        "classpath:/resources/**", "classpath:/templates/**", "/webjars/**",
                        "/WEB-INF/classes/static/**", "/recuperarSenha", "/criaAcesso");
    }
}
