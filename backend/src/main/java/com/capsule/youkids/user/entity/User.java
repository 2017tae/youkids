package com.capsule.youkids.user.entity;

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
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseTimeEntity {

    @Id
    @GeneratedValue(generator = "uuid")
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


}
