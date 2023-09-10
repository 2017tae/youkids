package com.capsule.youkids.user.entity;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Role {
    TYPE1("ROLE_USER"),
    TYPE2("ROLE_ADMIN"),
    TYPE3("ROLE_DELETED");

    String role;

    Role(String role){
        this.role = role;
    }

    public String value(){
        return role;
    }
}
