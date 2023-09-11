package com.capsule.youkids.user.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Role {
    USER("ROLE_USER"),
    ADMIN("ROLE_ADMIN"),
    DELETED("ROLE_DELETED");



    String role;

    Role(String role){
        this.role = role;
    }

    public String value(){
        return role;
    }
}
