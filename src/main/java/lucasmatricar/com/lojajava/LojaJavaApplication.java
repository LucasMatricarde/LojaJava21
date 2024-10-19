package lucasmatricar.com.lojajava;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@ComponentScan(basePackages = {"lucasmatricar.*"})
@EnableJpaRepositories(basePackages = {"lucasmatricar.com.lojajava.repository"})
@EntityScan(basePackages = "lucasmatricar.com.lojajava.model")
@EnableTransactionManagement
public class LojaJavaApplication {

	public static void main(String[] args) {
		SpringApplication.run(LojaJavaApplication.class, args);
	}

}
