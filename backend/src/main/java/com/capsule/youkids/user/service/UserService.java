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

  User addInfoUser(addUserInfoRequestDto request);

  boolean checkPartner(checkPartnerRequestDto request);

  GetMyInfoResponseDto getMyInfo(UUID userId);

  boolean modifyMyInfo(ModifyMyInfoRequestDto request, MultipartFile file);

  boolean deleteMyInfo(DeleteMyInfoRequestDto request);

  GoogleIdToken verifyToken(String payloads, String provider)
          throws GeneralSecurityException, IOException;

  User verifyUser(GoogleIdToken idToken);

  Token getToken(User user);

  boolean newUser(GoogleIdToken idToken, String provider);
 }
