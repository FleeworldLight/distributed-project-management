package com.team.dpm.base.core.core.domain.vo;


import com.team.dpm.base.core.core.domain.entity.SysUser;
import com.team.dpm.base.core.annotation.Excel;

/**
 * 用户对象 sys_user
 *
 * @author canghe
 */
public class SysUserVO extends SysUser {

    /**
     * 是否绑定企微
     */
    @Excel(name = "企微状态")
    private String userWxNameState;

    public String getUserWxNameState() {
        return userWxNameState;
    }

    public void setUserWxNameState(String userWxNameState) {
        this.userWxNameState = userWxNameState;
    }
}
