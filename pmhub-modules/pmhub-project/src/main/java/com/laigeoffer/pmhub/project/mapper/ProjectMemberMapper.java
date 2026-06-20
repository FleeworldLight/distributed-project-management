package com.team.dpm.project.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.team.dpm.project.domain.ProjectMember;
import com.team.dpm.project.domain.vo.project.member.ProjectMemberReqVO;
import com.team.dpm.project.domain.vo.project.member.ProjectMemberResVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author canghe
 * @date 2022-12-12 14:29
 */
public interface ProjectMemberMapper extends BaseMapper<ProjectMember> {

    List<ProjectMemberResVO> searchMember(@Param("data") ProjectMemberReqVO projectMemberReqVO);

    List<ProjectMemberResVO> queryExecutorList(@Param("projectId") String projectId);
    List<ProjectMemberResVO> queryTaskUserList(@Param("taskId") String taskId);
}
