package config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(basePackages = {"beans"}) // (basePackages = {"beans", "pachet2CuBeans", ...})
public class ProjectConfig {
}
