package com.capsule.youkids.global.config;

import com.capsule.youkids.user.service.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@RequiredArgsConstructor
public class JwtAuthenticationFilter extends GenericFilterBean {

    private final JwtUtil jwtUtil;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException, ServletException, IOException {

        String token = resolveToken((HttpServletRequest) request);

        if(token != null && jwtUtil.validateToken(token)){
            System.out.println(((HttpServletRequest)request).getRequestURI());
            Authentication authentication = jwtUtil.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(authentication);

        }
        chain.doFilter(request,response);
    }

    //Request Header에서 토큰 정보 추출
    private String resolveToken(HttpServletRequest request){
        String bearerToken = request.getHeader("Authorization");

        if(StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer")){
            System.out.println(bearerToken.substring(7));
            return bearerToken.substring(7);
        }
        return null;

    }
}

