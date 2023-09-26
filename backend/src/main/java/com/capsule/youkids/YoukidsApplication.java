package com.capsule.youkids;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
public class YoukidsApplication {

	public static void main(String[] args) {
		SpringApplication.run(YoukidsApplication.class, args);
	}

}
