package com.capsule.youkids.global.s3.service;

import java.io.File;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;

public interface AwsS3Service {

    public String uploadImg(MultipartFile multiFile) throws IOException;

    public File convert(MultipartFile multiFile) throws IOException;

    public void deleteFile(String deleteUrl);
}
