package com.team.dpm.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@SpringBootApplication
public class PmHubEurekaApplication {
    public static void main(String[] args) {
        SpringApplication.run(PmHubEurekaApplication.class, args);
    }
}
