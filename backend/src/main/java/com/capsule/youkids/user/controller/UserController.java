 package com.capsule.youkids.user.controller;

 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerDto;
 import com.capsule.youkids.user.entity.Role;
 import com.capsule.youkids.user.entity.User;
 import com.capsule.youkids.user.repository.UserRepository;
 import com.capsule.youkids.user.service.PrincipalService;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
 import com.google.api.client.http.javanet.NetHttpTransport;
 import com.google.api.client.json.jackson2.JacksonFactory;
 import java.io.IOException;
 import java.security.GeneralSecurityException;
 import java.util.Collections;
 import java.util.Map;
 import java.util.Optional;
 import java.util.UUID;
 import org.springframework.beans.factory.annotation.Value;
 import org.springframework.http.HttpStatus;
 import org.springframework.http.ResponseEntity;
 import org.springframework.web.bind.annotation.PostMapping;
 import org.springframework.web.bind.annotation.RequestBody;
 import org.springframework.web.bind.annotation.RequestHeader;
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RestController;

 import com.capsule.youkids.user.service.UserService;

 import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(value = "/user")
@RequiredArgsConstructor
public class UserController {

  private final UserService userService;

  private final UserRepository userRepository;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    private final PrincipalService principalService;

    @PostMapping("/verify-token")
    public ResponseEntity<?> verifyToken(@RequestHeader("Authorization") String payloads, @RequestHeader("Provider") String provider) throws GeneralSecurityException, IOException {

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
                return ResponseEntity.ok(user);
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
    public ResponseEntity<?> checkPartner(@RequestBody checkPartnerDto request){

        boolean check = userService.checkPartner(request);

        if(check) return new ResponseEntity<>(HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }


}
