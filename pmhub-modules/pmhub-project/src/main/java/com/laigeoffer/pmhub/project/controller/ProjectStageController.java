package com.team.dpm.project.controller;

import com.team.dpm.base.core.core.domain.AjaxResult;
import com.team.dpm.base.security.annotation.RequiresPermissions;
import com.team.dpm.project.domain.vo.project.ProjectVO;
import com.team.dpm.project.domain.vo.project.stage.ProjectStageVO;
import com.team.dpm.project.service.ProjectStageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @author canghe
 * @date 2022-12-19 16:35
 */

@RestController
@RequestMapping("/project/stage")
public class ProjectStageController {
    @Autowired
    private ProjectStageService projectStageService;

    /**
     * 根据项目id查询项目阶段
     * @param projectVO
     * @return
     */
    @RequiresPermissions("project:stage:list")
    @PostMapping("/list")
    public AjaxResult list(@RequestBody ProjectVO projectVO) {

        return AjaxResult.success(projectStageService.list(projectVO));
    }

    /**
     * 添加阶段
     * @param projectStageVO
     * @return
     */
    @RequiresPermissions("project:stage:add")
    @PostMapping("/add")
    public AjaxResult add(@RequestBody ProjectStageVO projectStageVO) {
        projectStageService.add(projectStageVO);
        return AjaxResult.success();
    }
    /**
     * 添加阶段
     * @param projectStageVO
     * @return
     */
    @RequiresPermissions("project:stage:edit")
    @PostMapping("/edit")
    public AjaxResult edit(@RequestBody ProjectStageVO projectStageVO) {
        projectStageService.edit(projectStageVO);
        return AjaxResult.success();
    }

    /**
     * 删除阶段
     * @param projectStageVO
     * @return
     */
    @RequiresPermissions("project:stage:delete")
    @DeleteMapping("/delete")
    public AjaxResult delete(@RequestBody ProjectStageVO projectStageVO) {
        if (projectStageService.selectTaskByStageId(projectStageVO.getStageId())) {
            return AjaxResult.error("该阶段下存在任务，不允许删除");
        }
        projectStageService.delete(projectStageVO);
        return AjaxResult.success();
    }
}
