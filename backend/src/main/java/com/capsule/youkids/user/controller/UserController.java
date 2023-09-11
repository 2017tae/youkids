 package com.capsule.youkids.user.controller;

 import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
 import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
 import com.capsule.youkids.user.entity.Role;
 import com.capsule.youkids.user.entity.Token;
 import com.capsule.youkids.user.entity.User;
 import com.capsule.youkids.user.repository.TokenRepository;
 import com.capsule.youkids.user.repository.UserRepository;
 import com.capsule.youkids.user.service.JwtUtil;
 import com.capsule.youkids.user.service.PrincipalService;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
 import com.google.api.client.http.javanet.NetHttpTransport;
 import com.google.api.client.json.jackson2.JacksonFactory;
 import com.nimbusds.oauth2.sdk.TokenRequest;
 import java.io.IOException;
 import java.security.GeneralSecurityException;
 import java.util.Collections;
 import java.util.Optional;
 import java.util.UUID;
 import javax.servlet.http.HttpServletResponse;
 import org.springframework.beans.factory.annotation.Value;
 import org.springframework.http.HttpStatus;
 import org.springframework.http.ResponseCookie;
 import org.springframework.http.ResponseEntity;
 import org.springframework.web.bind.annotation.DeleteMapping;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.PathVariable;
 import org.springframework.web.bind.annotation.PostMapping;
 import org.springframework.web.bind.annotation.PutMapping;
 import org.springframework.web.bind.annotation.RequestBody;
 import org.springframework.web.bind.annotation.RequestHeader;
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RequestPart;
 import org.springframework.web.bind.annotation.RestController;

 import com.capsule.youkids.user.service.UserService;

 import lombok.RequiredArgsConstructor;
 import org.springframework.web.multipart.MultipartFile;

 @RestController
@RequestMapping(value = "/user")
@RequiredArgsConstructor
public class UserController {

  private final UserService userService;

  private final UserRepository userRepository;
  private final JwtUtil jwtUtil;
  private final TokenRepository tokenRepository;


    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    private final PrincipalService principalService;

    @PostMapping("/verify-token")
    public ResponseEntity<?> verifyToken(@RequestHeader("Authorization") String payloads, @RequestHeader("Provider") String provider, HttpServletResponse httpServletResponse) throws GeneralSecurityException, IOException {

        System.out.println(payloads);

//        String idTokenString = (String) payloads.get("idToken");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new JacksonFactory())
                .setAudience(Collections.singletonList(googleClientId))
                .build();

//        GoogleIdToken idToken = verifier.verify(idTokenString);
        GoogleIdToken idToken = verifier.verify(payloads.substring(7));

        if (idToken != null) {
            GoogleIdToken.Payload payload = idToken.getPayload();
            String userId = payload.getSubject();
            String email = payload.getEmail();


            //            String name = (String) payload.get("name");

            System.out.println(payload);

            Optional<User> optionalUser = userRepository.findByProviderId(userId);
            User user;
            if (optionalUser.isPresent()) {
                user = optionalUser.get();
                System.out.println("already user");
                Token token = jwtUtil.generateToken(user);

                user.changeToken(token);
//                tokenRepository.save(token);
                userRepository.save(user);

                ResponseCookie cookie = ResponseCookie.from("accessToken", token.getAccessToken())
                        .maxAge(300000)
                        .path("/")
                        .sameSite("None")
                        .httpOnly(true)
                        .build();

                httpServletResponse.addHeader("Set-Cookie", cookie.toString());

                //CORS
                httpServletResponse.setHeader("Acess-Control-Allow-origin","*");
                httpServletResponse.setHeader("Access-Control-Allow-Credentials","true");
                httpServletResponse.setHeader("Access-Control-Allow-Methods","POST,GET,PUT,DELETE");

                return new ResponseEntity<>(HttpStatus.OK);
            } else {

                user = User.builder()
                        .userId(UUID.randomUUID())
                        .email(email)
                        .providerId(userId)
                        .role(Role.USER)
                        .provider(provider)
                        .build();

                userRepository.save(user);
            }
            System.out.println("new user!!");
            return ResponseEntity.ok("new_user");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token is invalid");
        }
    }

    @PostMapping("/addInfo")
    public ResponseEntity<?> addInfoUser(@RequestBody addUserInfoRequestDto request){

        boolean check = userService.addInfoUser(request);

        return new ResponseEntity<>(HttpStatus.CREATED);


    }

    @PostMapping("/checkpartner")
    public ResponseEntity<?> checkPartner(@RequestBody checkPartnerRequestDto request){

        boolean check = userService.checkPartner(request);

        //여기서 id가 없으면, partnerId 보내줘야 할수도 있음!
        if(check) return new ResponseEntity<>(HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/mypage/{userId}")
    public ResponseEntity<?> GetMyInfo(@PathVariable UUID userId){

        GetMyInfoResponseDto getMyInfoResponseDto = userService.getMyInfo(userId);

        return new ResponseEntity<>(getMyInfoResponseDto, HttpStatus.OK);

    }

    @PutMapping("")
    public ResponseEntity<?> ModifyMyInfo(@RequestPart(value = "dto") ModifyMyInfoRequestDto request, @RequestPart(value="files", required = false)
            MultipartFile file){

        boolean check = userService.modifyMyInfo(request, file);

        if(check) return new ResponseEntity<>(HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.BAD_REQUEST);

    }

    @DeleteMapping("")
    public ResponseEntity<?> DeleteMyInfo(@RequestBody DeleteMyInfoRequestDto request){

        boolean check = userService.deleteMyInfo(request);

        if(check) return new ResponseEntity<>(HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }


}
