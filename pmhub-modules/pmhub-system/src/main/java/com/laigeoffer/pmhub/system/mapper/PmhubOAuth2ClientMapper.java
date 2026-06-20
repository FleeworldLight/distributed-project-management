package com.team.dpm.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.team.dpm.system.domain.PmhubOAuth2Client;
import org.apache.ibatis.annotations.Mapper;

/**
 * OAuth2客户端 数据层
 *
 * @author canghe
 */
@Mapper
public interface PmhubOAuth2ClientMapper extends BaseMapper<PmhubOAuth2Client> {

}
