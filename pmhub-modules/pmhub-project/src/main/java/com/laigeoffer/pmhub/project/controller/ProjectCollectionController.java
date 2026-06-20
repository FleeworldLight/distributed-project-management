package com.team.dpm.project.controller;

import com.team.dpm.base.core.core.domain.AjaxResult;
import com.team.dpm.base.security.annotation.RequiresPermissions;
import com.team.dpm.project.domain.vo.project.ProjectVO;
import com.team.dpm.project.service.ProjectCollectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author canghe
 * @date 2022-12-15 16:32
 */

@RestController
@RequestMapping("/project")
public class ProjectCollectionController {

    @Autowired
    private ProjectCollectionService projectCollectionService;

    /**
     * 收藏项目
     * @param projectVO
     * @return
     */
    @RequiresPermissions("project:manage:collect")
    @PostMapping("/collect")
    public AjaxResult collectProject(@RequestBody ProjectVO projectVO) {

        return AjaxResult.success(projectCollectionService.collectProject(projectVO));
    }

    /**
     * 取消收藏项目
     * @param projectVO
     * @return
     */
    @RequiresPermissions("project:manage:cancelCollect")
    @PostMapping("/cancelCollect")
    public AjaxResult cancelCollectProject(@RequestBody ProjectVO projectVO) {

        return AjaxResult.success(projectCollectionService.cancelCollectProject(projectVO));
    }
}
