 package com.capsule.youkids.user.service;

 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;

 public interface UserService {

  boolean addInfoUser(addUserInfoRequestDto request);

  boolean checkPartner(checkPartnerRequestDto request);

 }