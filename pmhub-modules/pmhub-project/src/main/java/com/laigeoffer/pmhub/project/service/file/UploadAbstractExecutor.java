package com.team.dpm.project.service.file;

import com.team.dpm.base.core.core.domain.model.LoginUser;
import com.team.dpm.project.domain.vo.project.file.FileVO;
import org.springframework.web.multipart.MultipartFile;

/**
 * @author canghe
 * @date 2023-01-03 17:22
 */
public abstract class UploadAbstractExecutor {
    public abstract FileVO upload(LoginUser user, MultipartFile file, String id) throws Exception;
}
