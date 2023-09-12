package com.capsule.youkids.user.entity;

import com.capsule.youkids.user.dto.RequestDto.ModifyMyInfoRequestDto;
import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.UUID;

import javax.persistence.*;

import com.capsule.youkids.global.time.BaseTimeEntity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table
@Getter
@NoArgsConstructor
public class User extends BaseTimeEntity {

    @Id
//    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(columnDefinition = "BINARY(16)")
    private UUID userId;

    @Column
    private String provider;
    @Column
    private String providerId;

    @Column
    private String nickname;

    @Column
    private String email;

    @Column
    @Enumerated(EnumType.STRING)
    private Role role;

    @Column
    private String profileImage;

    @Column
    private boolean isCar;

    @Column(columnDefinition = "boolean default false")
    private boolean leader;

    @Column
    private String description;

    @Column
    private UUID partnerId;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "token_id")
    private Token token;

    // Builder 부분
    @Builder
    public User(UUID userId, String provider, String providerId, String email, Role role) {
        this.userId = userId;
        this.provider = provider;
        this.providerId = providerId;
        this.nickname = null;
        this.email = email;
        this.role = role;
        this.profileImage = null;
        this.isCar = false;
        this.leader = true;
        this.description = null;
        this.partnerId = null;
        this.token = null;
    }

    public void changeToken(Token token) {
        this.token = token;
    }

    public void addInfoToUser(addUserInfoRequestDto request) {
        this.nickname = request.getNickname();
        this.isCar = request.isCar();
        this.description = request.getDescription();
    }

    public void modifyUser(ModifyMyInfoRequestDto request) {
        this.nickname = request.getNickname();
    }

    // 서로 맞팔이 되면 partnerId 등록
    public void modifyUserPartner(UUID partnerId) {
        this.partnerId = partnerId;

    }

    //일단 두 방향 다 가능하도록 설정함(한 방향이 맞는듯...)
    public void changeToDeleted(User user) {
        if (user.role == Role.USER) {
            user.role = Role.DELETED;
        } else if (user.role == Role.DELETED) {
            user.role = Role.USER;
        }
    }

}
