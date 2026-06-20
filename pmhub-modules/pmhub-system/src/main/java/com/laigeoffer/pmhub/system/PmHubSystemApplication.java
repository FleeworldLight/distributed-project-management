package com.team.dpm.system;

import com.team.dpm.base.security.annotation.EnableCustomConfig;
import com.team.dpm.base.security.annotation.EnablePmFeignClients;
import com.team.dpm.base.swagger.annotation.EnableCustomSwagger2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author canghe
 * @description 系统模块
 * @create 2024-04-24-15:29
 */
@EnableCustomConfig
@EnablePmFeignClients
@EnableCustomSwagger2
@SpringBootApplication
public class PmHubSystemApplication {
    public static void main(String[] args) {
        SpringApplication.run(PmHubSystemApplication.class, args);
    }
}