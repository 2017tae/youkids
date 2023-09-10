package com.capsule.youkids.global.config;

import com.capsule.youkids.user.service.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@EnableWebSecurity
@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtUtil jwtUtil;

    private final PrincipalOauth2UserService principalOauth2UserService;


//    @Value("${jwt.whiteList}")
//    private String[] whiteList;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
        http.formLogin().disable()
                .httpBasic().disable()
                .csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                //아랫줄 대체
                //화이트 리스트의 모든 url패스.
                .antMatchers("").permitAll()
                // .antMatchers("/swagger/**","/swagger-resources/**","/health","/v3/api-docs/**","/swagger-ui/**","/api/boardfile/**","/api/user/logout","/api/user/login/**", "/api/user/new/**","/api/board/**","/api/shop/**").permitAll() // 해당 api에서는 모든 요청을 허가한다는 설정
                .antMatchers().access("hasRole('ADMIN')") // ADMIN일때 실행
                .anyRequest().authenticated() // 이 밖에 모든 요청에 대해서 인증을 필요로 한다는 설정
                .and()
                .oauth2Login().userInfoEndpoint().userService(principalOauth2UserService);

        return http.build();
    }

//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }

}
