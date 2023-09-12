 package com.capsule.youkids.user.controller;

 import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
 import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
 import com.capsule.youkids.user.entity.Token;
 import com.capsule.youkids.user.entity.User;
 import com.capsule.youkids.user.repository.TokenRepository;
 import com.capsule.youkids.user.service.PrincipalService;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
 import java.io.IOException;
 import java.security.GeneralSecurityException;
 import java.util.Objects;
 import java.util.UUID;
 import javax.servlet.http.HttpServletResponse;
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

    @PostMapping("/verify-token")
    public ResponseEntity<?> verifyToken(@RequestHeader("Authorization") String payloads, @RequestHeader("Provider") String provider, HttpServletResponse httpServletResponse) throws GeneralSecurityException, IOException {

        System.out.println(payloads);

        GoogleIdToken idToken =  userService.verifyToken(payloads, provider);


        if (idToken != null) {

            User user =  userService.verifyUser(idToken);
            if(Objects.isNull(user)) System.out.println("good");

            if (!Objects.isNull(user)) {

                Token token = userService.getToken(user);

                // token 쿠키에 담아서 보내기(https 의 경우, secure(true)로)
                ResponseCookie cookie = ResponseCookie.from("accessToken", token.getAccessToken())
                        .maxAge(300000)
//                        .secure(true)
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
                
                // 회원가입 루트
                boolean check = userService.newUser(idToken, provider);

                if(check){
                    return new ResponseEntity<>("new_user", HttpStatus.OK);
                }
            }

            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Social Token is invalid");
        }
    }


    @PostMapping("/addInfo")
    public ResponseEntity<?> addInfoUser(@RequestBody addUserInfoRequestDto request, HttpServletResponse httpServletResponse){

        User user = userService.addInfoUser(request);

        // 이 때, jwt 같이 보내줘야 함!
        if(!Objects.isNull(user)){

            Token token = userService.getToken(user);

            // token 쿠키에 담아서 보내기(https 의 경우, secure(true)로)
            ResponseCookie cookie = ResponseCookie.from("accessToken", token.getAccessToken())
                    .maxAge(300000)
//                        .secure(true)
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
        }

        else return new ResponseEntity<>(HttpStatus.CREATED);

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
