package com.team.dpm.workflow.service;

import com.team.dpm.base.core.core.domain.PageQuery;
import com.team.dpm.base.core.core.page.Table2DataInfo;
import com.team.dpm.workflow.core.domain.ProcessQuery;
import com.team.dpm.workflow.domain.WfMaterialsScrappedProcess;
import com.team.dpm.base.core.core.domain.entity.WfTaskProcess;
import com.team.dpm.base.core.core.domain.dto.ApprovalSetDTO;
import com.team.dpm.workflow.domain.dto.MaterialsApprovalSetDTO;
import com.team.dpm.workflow.domain.vo.MaterialsApprovalSetVO;
import com.team.dpm.workflow.domain.vo.WfDeployVo;

import java.util.List;

/**
 * @author canghe
 * @createTime 2022/6/30 9:03
 */
public interface IWfDeployService {

    Table2DataInfo<WfDeployVo> queryPageList(ProcessQuery processQuery, PageQuery pageQuery);

    Table2DataInfo<WfDeployVo> queryPublishList(String processKey, PageQuery pageQuery);

    void updateState(String definitionId, String stateCode);

    String queryBpmnXmlById(String definitionId);

    void deleteByIds(List<String> deployIds);

    void approvalSet(MaterialsApprovalSetDTO approvalSetDTO, String type);
    MaterialsApprovalSetVO queryApprovalSet(String type, String taskId);
    boolean updateApprovalSet(ApprovalSetDTO approvalSetDTO, String type);
    boolean updateApprovalSet2(ApprovalSetDTO approvalSetDTO, String type);
    boolean insertApprovalSet();
    WfTaskProcess insertWfTaskProcess(String extraId, String type, String approved, String definitionId, String deploymentId);
    boolean insertOrUpdateApprovalSet(String extraId, String type, String approved, String definitionId, String deploymentId);
    List<WfMaterialsScrappedProcess> insertScrappedProcess(List<String> ids, MaterialsApprovalSetVO materialsApprovalSetVO);
    List<WfTaskProcess> selectList(List<String> taskId);
    List<WfTaskProcess> selectWfTaskProcessList(List<String> extraId, String type);
    void updateProviderApproval(String providerId);
    List<WfMaterialsScrappedProcess> selectScrappedList(List<String> ids);
}
