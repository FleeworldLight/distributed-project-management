package com.team.dpm.project.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.github.pagehelper.PageInfo;
import com.team.dpm.project.domain.vo.project.ProjectVO;
import com.team.dpm.project.domain.vo.project.log.LogVO;
import com.team.dpm.project.domain.vo.project.log.ProjectLogVO;
import com.team.dpm.project.domain.ProjectLog;

/**
 * @author canghe
 * @date 2022-12-21 11:40
 */
public interface ProjectLogService extends IService<ProjectLog> {
    void run(LogVO logVO);

    PageInfo<ProjectLogVO> list(ProjectVO projectVO);
}
