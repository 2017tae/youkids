 package com.capsule.youkids.user.service;

 import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
 import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
 import com.capsule.youkids.user.entity.User;
 import java.util.Objects;
 import java.util.UUID;
 import javax.transaction.Transactional;
 import org.springframework.stereotype.Service;

 import com.capsule.youkids.user.repository.UserRepository;

 import lombok.RequiredArgsConstructor;
 import org.springframework.web.multipart.MultipartFile;

 @Service
 @RequiredArgsConstructor
 public class UserServiceImpl implements UserService{

 	private final UserRepository userRepository;


     @Override
     public boolean addInfoUser(addUserInfoRequestDto request) {

         User user = userRepository.findById(request.getUserId()).orElseThrow(()-> new IllegalArgumentException());

         user.addInfoToUser(request);

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

     @Override
     public GetMyInfoResponseDto getMyInfo(UUID userId) {

         User user = userRepository.findById(userId).orElseThrow(()-> new IllegalArgumentException());

         return new GetMyInfoResponseDto(user);
     }

     @Transactional
     @Override
     public boolean modifyMyInfo(ModifyMyInfoRequestDto request, MultipartFile file) {

         User user = userRepository.findById(request.getUserId()).orElseThrow(()->new IllegalArgumentException());

         // S3를 통해 저장---------------------

        //-----------------------------------
         user.modifyUser(request);

         if(request.isPartner()){
             // Partner가 있으면,
             if(request.getUserId() != user.getPartnerId()) return false;
         }else{
             // Partner가 없으면 firebase로 보내기

         }


         return true;
     }

     @Override
     public boolean deleteMyInfo(DeleteMyInfoRequestDto request) {

         User user = userRepository.findById(request.getUserId()).orElseThrow(()-> new IllegalArgumentException());

         user.changeToDeleted(user);

         userRepository.save(user);

         return true;
     }
 }
