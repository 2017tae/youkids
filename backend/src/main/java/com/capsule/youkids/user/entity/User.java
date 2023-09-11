package com.capsule.youkids.user.entity;

import com.capsule.youkids.user.dto.RequestDto.addUserInfoRequestDto;
import com.capsule.youkids.user.dto.ResponseDto.GetMyInfoResponseDto;
import java.util.UUID;

import javax.persistence.*;

import org.hibernate.annotations.GenericGenerator;

import com.capsule.youkids.global.time.BaseTimeEntity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseTimeEntity {

    @Id
    @GenericGenerator(name = "uuid", strategy = "uuid")
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

    public void updateUser(addUserInfoRequestDto request){
        this.nickname = request.getNickname();
        this.isCar = request.isCar();
        this.description=request.getDescription();

    }


}
