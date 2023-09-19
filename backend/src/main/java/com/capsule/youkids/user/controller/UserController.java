package com.capsule.youkids.user.controller;

import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
import com.capsule.youkids.user.entity.Token;
import com.capsule.youkids.user.entity.User;
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

    // social login을 눌렀을 때
    @PostMapping("/verify-token")
    public ResponseEntity<?> verifyToken(@RequestHeader("Authorization") String payloads,
            @RequestHeader("Provider") String provider, HttpServletResponse httpServletResponse)
            throws GeneralSecurityException, IOException {

        // paylaods가 유효한 토큰인지 Google 등을 통해서 한번 더 확인
        GoogleIdToken idToken = userService.verifyToken(payloads, provider);

        // 유효하다면
        if (idToken != null) {

            // User가 이미 등록이 되어있는지 확인
            User user = userService.verifyUser(idToken);

            // 유저가 이미 등록된 유저라면,
            if (!Objects.isNull(user)) {

                // JWT를 발행
                Token token = userService.getToken(user);

                // JWT를 쿠키에 담아서 보내기(https 의 경우, secure(true)로)
                ResponseCookie cookie = ResponseCookie.from("accessToken", token.getAccessToken())
                        .maxAge(300000)
//                        .secure(true)
                        .path("/")
                        .sameSite("None")
                        .httpOnly(true)
                        .build();

                httpServletResponse.addHeader("Set-Cookie", cookie.toString());

                //CORS
                httpServletResponse.setHeader("Acess-Control-Allow-origin", "*");
                httpServletResponse.setHeader("Access-Control-Allow-Credentials", "true");
                httpServletResponse.setHeader("Access-Control-Allow-Methods",
                        "POST,GET,PUT,DELETE");

                return new ResponseEntity<>(HttpStatus.OK);
            } else {
                // 등록된 유저가 아니라면

                // 회원가입 루트(DB에 일정부분 등록 -> email, provider, provider_id)
                boolean check = userService.newUser(idToken, provider);

                if (check) {
                    // "new_user"라고 body에 담아 보냄으로써 프론트에서 확인
                    return new ResponseEntity<>("new_user", HttpStatus.OK);
                }
            }

            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            //Token이 유효하지 않다면,
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Social Token is invalid");
        }
    }


    // 회원가입시 추가정보 입력
    @PostMapping("/addInfo")
    public ResponseEntity<?> addInfoUser(@RequestBody addUserInfoRequestDto request,
            HttpServletResponse httpServletResponse) {

        System.out.println(request.isCar());
        System.out.println(request.getUserId());

        User user = userService.addInfoUser(request);

        if (!Objects.isNull(user)) {

            // 이 때, JWT 같이 보내줘야 함!
            Token token = userService.getToken(user);

            // token 쿠키에 담아서 보내기(https 의 경우, secure(true)로)
            ResponseCookie cookie = ResponseCookie.from("accessToken", token.getAccessToken())
                    .maxAge(300000)
                    //.secure(true)
                    .path("/")
                    .sameSite("None")
                    .httpOnly(true)
                    .build();

            httpServletResponse.addHeader("Set-Cookie", cookie.toString());

            //CORS
            httpServletResponse.setHeader("Acess-Control-Allow-origin", "*");
            httpServletResponse.setHeader("Access-Control-Allow-Credentials", "true");
            httpServletResponse.setHeader("Access-Control-Allow-Methods", "POST,GET,PUT,DELETE");

            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.CREATED);
        }

    }

    // partner로 선택한 유저 유무 파악
    @PostMapping("/checkpartner")
    public ResponseEntity<?> checkPartner(@RequestBody checkPartnerRequestDto request) {

        // partner가 있는지 유무 파악
        boolean check = userService.checkPartner(request);

        //여기서 id가 없으면, partnerId 보내줘야 할수도 있음!
        if (check) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    // Mypage에서 User의 정보만 GET
    @GetMapping("/mypage/{userId}")
    public ResponseEntity<?> GetMyInfo(@PathVariable UUID userId) {

        GetMyInfoResponseDto getMyInfoResponseDto = userService.getMyInfo(userId);

        return new ResponseEntity<>(getMyInfoResponseDto, HttpStatus.OK);

    }

    //  유저 본인의 정보 수정( 이 때, 사진 처리)
    @PutMapping("")
    public ResponseEntity<?> ModifyMyInfo(
            @RequestPart(value = "dto") ModifyMyInfoRequestDto request,
            @RequestPart(value = "files", required = false)
            MultipartFile file) {

        // 유저 정보 수정 및 사진 처리
        boolean check = userService.modifyMyInfo(request, file);

        if (check) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }

    // 유저 soft-delete
    @DeleteMapping("")
    public ResponseEntity<?> DeleteMyInfo(@RequestBody DeleteMyInfoRequestDto request) {

        boolean check = userService.deleteMyInfo(request);

        if (check) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }


}
