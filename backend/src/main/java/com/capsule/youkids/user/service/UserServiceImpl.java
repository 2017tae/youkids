 package com.capsule.youkids.user.service;

 import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
 import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
 import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
 import com.capsule.youkids.user.entity.Role;
 import com.capsule.youkids.user.entity.Token;
 import com.capsule.youkids.user.entity.User;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
 import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
 import com.google.api.client.http.javanet.NetHttpTransport;
 import com.google.api.client.json.jackson2.JacksonFactory;
 import java.io.IOException;
 import java.security.GeneralSecurityException;
 import java.util.Collections;
 import java.util.Objects;
 import java.util.Optional;
 import java.util.UUID;
 import org.springframework.beans.factory.annotation.Value;
 import org.springframework.stereotype.Service;

 import com.capsule.youkids.user.repository.UserRepository;

 import lombok.RequiredArgsConstructor;
 import org.springframework.transaction.annotation.Transactional;
 import org.springframework.web.multipart.MultipartFile;

 @Service
 @RequiredArgsConstructor
 public class UserServiceImpl implements UserService{

 	private final UserRepository userRepository;
     private final JwtUtil jwtUtil;

     @Value("${spring.security.oauth2.client.registration.google.client-id}")
     private String googleClientId;


     @Transactional
     @Override
     public User addInfoUser(addUserInfoRequestDto request) {

         User user = userRepository.findById(request.getUserId()).orElseThrow(()-> new IllegalArgumentException());

         user.addInfoToUser(request);

         userRepository.save(user);

         //여기서 partner에 팔로우 보내야 함!--------------

         //--------------------------------------------

         return user;
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

     @Transactional
     @Override
     public boolean deleteMyInfo(DeleteMyInfoRequestDto request) {

         User user = userRepository.findById(request.getUserId()).orElseThrow(()-> new IllegalArgumentException());

         user.changeToDeleted(user);

         userRepository.save(user);

         return true;
     }

     @Transactional
     @Override
     public GoogleIdToken verifyToken(String payloads, String provider)
             throws GeneralSecurityException, IOException {

         GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new JacksonFactory())
                 .setAudience(Collections.singletonList(googleClientId))
                 .build();

         System.out.println(payloads);

         GoogleIdToken idToken = verifier.verify(payloads.substring(7));

         return idToken;
     }

     @Override
     public User verifyUser(GoogleIdToken idToken) {

         GoogleIdToken.Payload payload = idToken.getPayload();
         String providerId = payload.getSubject();

         User optionalUser = userRepository.findByProviderId(providerId);

         return optionalUser;
     }

     @Transactional
     @Override
     public Token getToken(User user) {

         Token token = jwtUtil.generateToken(user);

         user.changeToken(token);
         userRepository.save(user);

         return token;
     }

     @Transactional
     @Override
     public boolean newUser(GoogleIdToken idToken, String provider) {

         GoogleIdToken.Payload payload = idToken.getPayload();

         User user = User.builder()
                 .userId(UUID.randomUUID())
                 .email(payload.getEmail())
                 .providerId(payload.getSubject())
                 .role(Role.USER)
                 .provider(provider)
                 .build();

         userRepository.save(user);

         return true;
     }


 }
