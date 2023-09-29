package com.capsule.youkids.user.service;

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
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface UserService {

    // google auth token 유효 확인
    GoogleIdToken verifyToken(String payloads, String provider)
            throws GeneralSecurityException, IOException;

    // User가 이미 등록이 되어있는지 확인
    User verifyUser(GoogleIdToken idToken);

    // JWT를 발행 및 저장
    Token getToken(User user);

    // 회원가입 루트(DB에 일정부분 등록 -> email, provider, provider_id)
    User newUser(GoogleIdToken idToken, String provider);

    // 회원가입시 추가정보 입력
    User addInfoUser(addUserInfoRequestDto request);

    // partner로 선택한 유저 유무 파악
    boolean checkPartner(checkPartnerRequestDto request);

    // 본인 회원 유저 정보 조회
    GetMyInfoResponseDto getMyInfo(UUID userId);

    // 본인 회원 유저 수정
    boolean modifyMyInfo(ModifyMyInfoRequestDto request, MultipartFile file) throws Exception;

    // 본인 회원 휴면유저로 변경
    boolean deleteMyInfo(DeleteMyInfoRequestDto request);

}
