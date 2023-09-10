package com.capsule.youkids.user.entity;

import lombok.*;

import javax.persistence.*;

@Entity
@Table
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Token {

    @Id
    @Column(name="token_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long tokenIndex;

    @Column
    private String tokenType;

    @Column
    private String accessToken;


}
