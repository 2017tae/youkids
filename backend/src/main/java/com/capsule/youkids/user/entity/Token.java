package com.capsule.youkids.user.entity;

import lombok.*;

import javax.persistence.*;

@Entity
@Table
@Getter
@NoArgsConstructor
public class Token {

    @Id
    @Column(name = "token_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long tokenIndex;

    @Column
    private String tokenType;

    @Column
    private String accessToken;

    @OneToOne(mappedBy = "token")
    private User user;

    @Builder
    public Token(Long tokenIndex, String tokenType, String accessToken, User user) {
        this.tokenIndex = tokenIndex;
        this.tokenType = tokenType;
        this.accessToken = accessToken;
        this.user = user;
    }
}
