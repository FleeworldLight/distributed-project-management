package com.team.dpm.project.controller;

import com.team.dpm.base.core.core.domain.AjaxResult;
import com.team.dpm.base.security.annotation.RequiresPermissions;
import com.team.dpm.project.domain.vo.project.ProjectVO;
import com.team.dpm.project.service.ProjectLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author canghe
 * @date 2022-12-21 14:28
 */

@RestController
@RequestMapping("/project/log")
public class ProjectLogController {

    @Autowired
    private ProjectLogService projectLogService;

    /**
     * 项目动态
     * @param projectVO
     * @return
     */
    @PostMapping("/list")
    @RequiresPermissions("project:log:list")
    public AjaxResult list(@RequestBody ProjectVO projectVO) {
        return AjaxResult.success(projectLogService.list(projectVO));
    }

}
