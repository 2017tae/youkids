package com.capsule.youkids.user.service;

import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupJoinRepository;
import com.capsule.youkids.user.dto.RequestDto.DeleteMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.PartnerRegistRequestDto;
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
import javax.servlet.http.Part;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.capsule.youkids.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.capsule.youkids.global.s3.service.AwsS3Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final GroupInfoRepository groupInfoRepository;
    private final GroupJoinRepository groupJoinRepository;
    private final AwsS3Service awsS3Service;


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
    public User newUser(GoogleIdToken idToken, String provider) {

        GoogleIdToken.Payload payload = idToken.getPayload();

        User user = User.builder()
                .userId(UUID.randomUUID())
                .email(payload.getEmail())
                .providerId(payload.getSubject())
                .role(Role.USER)
                .provider(provider)
                .build();

        userRepository.save(user);

        return user;
    }

    // 새로운 유저가 추가정보를 입력 후 JWT 발행
    @Transactional
    @Override
    public User addInfoUser(addUserInfoRequestDto request) {

        User user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED)
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
                .groupName("내 그룹 1")
                .build();

        groupJoinRepository.save(groupJoin);

        //여기서 partner에 팔로우 보내야 함!--------------

        //--------------------------------------------

        return user;
    }

    // Partner유저 유무를 파악한다.
    @Override
    public PartnerInfoDto checkPartner(checkPartnerRequestDto request) {

        User user = userRepository.findByEmailAndRoleNot(request.getPartnerEmail(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        if (user == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user");
        } else if (user.getUserId().equals(request.getUserId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "same user");
        }

        return new PartnerInfoDto(user);

    }

    @Override
    public boolean registPartner(PartnerRegistRequestDto request) {
        Optional<User> user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED);
        Optional<User> partner = userRepository.findByUserIdAndRoleNot(request.getPartnerId(), Role.DELETED);

        if (user.isPresent() && partner.isPresent()) {
            // 서로를 파트너로 등록하고
            user.get().modifyUserPartner(request.getPartnerId());
            partner.get().modifyUserPartner(request.getUserId());
            // 파트너는 리더 ㄴㄴ
            partner.get().changeLeaderStatus(false);
            userRepository.save(user.get());
            userRepository.save(partner.get());
            return true;
        }
        return false;
    }

    // 현재 유저 정보를 파악한다.(유저만)
    @Override
    public GetMyInfoResponseDto getMyInfo(UUID userId) {

        User user = userRepository.findByUserIdAndRoleNot(userId, Role.DELETED)
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
    public boolean modifyMyInfo(ModifyMyInfoRequestDto request, MultipartFile file) throws Exception {

        User user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        // S3를 통해 저장---------------------

        // 사진 변경 내역이 있으면
        if (request.isImageChanged()) {

            // 만약에 기존에 프사가 있었는데 삭제된거면
            if (file == null) {

                // 기존 프사를 S3에서 삭제하고
                awsS3Service.deleteFile(user.getProfileImage());
                // 내 프사도 삭제
                user.deleteProfileImage();

                // 들어온 파일이 있으면
            } else {
                try {
                    // S3에 넣고 프사 등록혀
                    user.modifyProfileImage(awsS3Service.uploadFile(file));
                } catch (Exception e) {
                    throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "upload failed");
                }
            }
        }

        userRepository.save(user);

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

        User user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED)
                .orElseThrow(()-> new IllegalArgumentException());

        user.changeToDeleted(user);

        userRepository.save(user);

        return true;
    }


}
