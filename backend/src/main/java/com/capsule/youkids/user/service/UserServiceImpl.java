package com.capsule.youkids.user.service;

import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupJoinRepository;
import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.checkPartnerRequestDto;
import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
import com.capsule.youkids.user.dto.view.GetMyInfoDto;
import com.capsule.youkids.user.dto.view.PartnerInfoDto;
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
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final GroupInfoRepository groupInfoRepository;
    private final GroupJoinRepository groupJoinRepository;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;


    // Auth Token이 유효한지 확인
    @Transactional
    @Override
    public GoogleIdToken verifyToken(String payloads, String provider)
            throws GeneralSecurityException, IOException {

        // 검증 과정에서 이 ID가 토큰의 aud (Audience) 필드와 일치하는지 확인
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(),
                new JacksonFactory())
                .setAudience(Collections.singletonList(googleClientId))
                .build();

        GoogleIdToken idToken = verifier.verify(payloads.substring(7));

        return idToken;
    }

    // Auth : Google -> 이미 있는 유저인지 확인
    @Override
    public User verifyUser(GoogleIdToken idToken) {

        GoogleIdToken.Payload payload = idToken.getPayload();
        String providerId = payload.getSubject();

        Optional<User> optionalUser = userRepository.findByProviderId(providerId);

        if(optionalUser.isEmpty()){
            return null;
        }else{
            return optionalUser.get();
        }

    }

    // JWT 발행한다.
    @Transactional
    @Override
    public Token getToken(User user) {

        Token token = jwtUtil.generateToken(user);

        user.changeToken(token);
        userRepository.save(user);

        return token;
    }

    // 새로운 유저일 경우, 저장(이 때, 바로 JWT 발행 X)
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

    // 새로운 유저가 추가정보를 입력 후 JWT 발행
    @Transactional
    @Override
    public User addInfoUser(addUserInfoRequestDto request) {

        User user = userRepository.findByEmailAndRoleNot(request.getEmail(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        user.addInfoToUser(request);

        userRepository.save(user);

        // Group 만들기
        GroupInfo groupInfo = GroupInfo.builder()
                .groupId(user.getUserId())
                .leaderId(user.getUserId())
                .groupImg(null)
                .build();

        groupInfoRepository.save(groupInfo);

        GroupJoin groupJoin = GroupJoin.builder()
                .groupId(user.getUserId())
                .userId(user.getUserId())
                .groupName(null)
                .build();

        groupJoinRepository.save(groupJoin);

        //여기서 partner에 팔로우 보내야 함!--------------

        //--------------------------------------------

        return user;
    }

    // Partner유저 유무를 파악한다.
    @Override
    public boolean checkPartner(checkPartnerRequestDto request) {

        User user = userRepository.findByEmailAndRoleNot(request.getPartnerEmail(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        if (Objects.isNull(user)) {

            return false;
        }

        return true;

    }

    // 현재 유저 정보를 파악한다.(유저만)
    @Override
    public GetMyInfoResponseDto getMyInfo(String email) {

        User user = userRepository.findByEmailAndRoleNot(email, Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        UUID partnerId = user.getPartnerId();

        if(Objects.isNull(partnerId)){

            GetMyInfoResponseDto getMyInfoResponseDto = new GetMyInfoResponseDto(new GetMyInfoDto(user), null);

            return getMyInfoResponseDto;
        }


        User partner = userRepository.findById(partnerId).orElseThrow(()-> new IllegalArgumentException());

        GetMyInfoResponseDto getMyInfoResponseDto = new GetMyInfoResponseDto(new GetMyInfoDto(user), new PartnerInfoDto(partner));

        return getMyInfoResponseDto;
    }

    // 유저의 정보만 수정한다.
    @Transactional
    @Override
    public boolean modifyMyInfo(ModifyMyInfoRequestDto request, MultipartFile file) {

        User user = userRepository.findByEmailAndRoleNot(request.getEmail(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        // S3를 통해 저장---------------------

        //-----------------------------------
        user.modifyUser(request);

        if (request.isPartner()) {
            // Partner가 있으면,
            if (user.getUserId() != user.getPartnerId()) {
                return false;
            }
        } else {
            // Partner가 없으면 firebase로 보내기

        }

        return true;
    }

    // 해당 유저를 휴면 계정으로 만든다.
    @Transactional
    @Override
    public boolean deleteMyInfo(DeleteMyInfoRequestDto request) {

        User user = userRepository.findByEmailAndRoleNot(request.getEmail(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        user.changeToDeleted(user);

        userRepository.save(user);

        return true;
    }


}
