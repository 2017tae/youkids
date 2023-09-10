package com.capsule.youkids.user.service;


import com.capsule.youkids.user.entity.Token;
import io.jsonwebtoken.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.security.core.authority.SimpleGrantedAuthority;


import javax.annotation.PostConstruct;
import java.sql.Date;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collection;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JwtUtil {

    @Value("${jwt.key}")
    private String key;

    @Value("${jwt.accessTokenExpirationTime.int}")
    private int accessTokenExpirationTime;

//    @Value("${jwt.refreshTokenExpirationTime.int}")
//    private int refreshTokenExpirationTime;


    // 객체 초기화, secreKey를 Base64로 인코딩한다.
    @PostConstruct
    protected void init(){
        key = Base64.getEncoder().encodeToString(key.getBytes());
    }

    // 로그인 시 accessToken과 refreshToken을 생성해준다.
    public Token generateToken(Authentication authentication){

        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority).collect(Collectors.joining(","));

        //accessToken 관리
        String accessToken = Jwts.builder()
                .setSubject(authentication.getName())
                .claim("role",authorities)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis()+accessTokenExpirationTime))
                .signWith(SignatureAlgorithm.HS256,key)
                .compact();

        return Token.builder()
                .tokenType("Bearer")
                .accessToken(accessToken)
                .build();
    }

    // JWT 토큰에서 인증 정보 조회
    public Authentication getAuthentication(String token){

        Claims claims = parseClaims(token);

        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get("role").toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());

        UserDetails principal = new org.springframework.security.core.userdetails.User(claims.getSubject(),"", authorities);

        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
    }

    public Claims parseClaims(String token){

        try{
            return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
        }catch(ExpiredJwtException e){
            return e.getClaims();
        }
    }

    public Boolean validateToken(String token){

        try {
            Claims claims = Jwts.parser().setSigningKey(key).parseClaimsJws(token).getBody();
            return true;
        } catch(SignatureException ex){
            System.out.println("Invalid JWT signautre");
        } catch(MalformedJwtException ex){
            System.out.println("Invalid JWT token");
        } catch(ExpiredJwtException ex){
            System.out.println("Expired JWT token");
        } catch(UnsupportedJwtException ex){
            System.out.println("Unsupported JWT token");
        } catch(IllegalArgumentException ex){
            System.out.println("JWT claims string is empty");
        }
        return false;



    }


}
