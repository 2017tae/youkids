 package com.capsule.youkids.user.service;

 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
 import com.capsule.youkids.user.entity.User;
 import java.util.Objects;
 import org.springframework.stereotype.Service;

 import com.capsule.youkids.user.repository.UserRepository;

 import lombok.RequiredArgsConstructor;

 @Service
 @RequiredArgsConstructor
 public class UserServiceImpl implements UserService{

 	private final UserRepository userRepository;


     @Override
     public boolean addInfoUser(addUserInfoRequestDto request) {

         User user = userRepository.findById(request.getUserId()).orElseThrow(()-> new IllegalArgumentException());

         user.updateUser(request);

         userRepository.save(user);

         //여기서 partner에 팔로우 보내야 함!--------------

         //--------------------------------------------

         return true;
     }

     @Override
     public boolean checkPartner(checkPartnerRequestDto request) {

         User user = userRepository.findByEmail(request.getPartnerEmail());

         if(Objects.isNull(user.getPartnerId())){

             return false;
         }

         return true;

     }
 }
