 package com.capsule.youkids.user.service;

 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
 import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
 import java.util.UUID;

 public interface UserService {

  boolean addInfoUser(addUserInfoRequestDto request);

  boolean checkPartner(checkPartnerRequestDto request);

  GetMyInfoResponseDto getMyInfo(UUID userId);

 }
