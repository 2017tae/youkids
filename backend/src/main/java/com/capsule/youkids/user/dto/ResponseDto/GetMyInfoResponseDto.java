package com.capsule.youkids.user.dto.ResponseDto;

import com.capsule.youkids.user.dto.view.GetMyInfoDto;
import com.capsule.youkids.user.dto.view.PartnerInfoDto;
import com.capsule.youkids.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class GetMyInfoResponseDto {

    private GetMyInfoDto getMyInfoDto;

    private PartnerInfoDto partnerInfoDto;


    public GetMyInfoResponseDto(GetMyInfoDto getMyInfoDto, PartnerInfoDto partnerInfoDto) {
        this.getMyInfoDto = getMyInfoDto;
        this.partnerInfoDto = partnerInfoDto;

    }

}
