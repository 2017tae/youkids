package com.capsule.youkids.global.s3.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import java.io.IOException;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class AwsS3ServiceImpl implements AwsS3Service {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    // 파일 업로드
    @Override
    public String uploadFile(MultipartFile multiFile) throws IOException {

        // 파일 이름에서 확장자 추출
        String fileName = multiFile.getOriginalFilename();
        String fileExtension = StringUtils.getFilenameExtension(fileName);

        // 파일 확장자를 기반으로 MIME 유형 식별
        String contentType = multiFile.getContentType(); // 기본값 설정
        
        // 확장자가 존재하는 경우
        if (fileExtension != null) {
            // 확장자에 맞는 content type 삽입
            switch (fileExtension.toLowerCase()) {
                case "jpg":
                case "jpeg":
                    contentType = "image/jpeg";
                    break;
                case "png":
                    contentType = "image/png";
                    break;
                case "gif":
                    contentType = "image/gif";
                    break;
                case "mp4":
                    contentType = "video/mp4";
                    break;
                case "avi":
                    contentType = "video/avi";
                    break;
                case "mpeg":
                    contentType = "video/mpeg";
                    break;
            }
        }

        // content 타입 String 분리
        String[] splitContent = contentType.split("/");

        // 파일 이름을 UUID로 생성
        String fullName = splitContent[0] + "/" + UUID.randomUUID() + "." + splitContent[1]; // img 폴더에 저장

        // MIME 타입 설정
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(multiFile.getSize());
        metadata.setContentType(contentType);

        // Amazon S3에 업로드
        amazonS3.putObject(bucket, fullName, multiFile.getInputStream(), metadata);

        // DB에 저장하기 위한 URL 리턴
        return amazonS3.getUrl(bucket, fullName).toString();
    }

    @Override
    public void deleteFile(String deleteUrl) {
        String deleteFile = deleteUrl.split("/")[3] + "/" + deleteUrl.split("/")[4];
        amazonS3.deleteObject(bucket, deleteFile);
    }
}

