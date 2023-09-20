package com.capsule.youkids.global.s3.service;

import java.io.File;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;

public interface AwsS3Service {

    public String uploadFile(MultipartFile multiFile, String type) throws IOException;

    public void deleteFile(String deleteUrl, String type);
}
