package com.myself.deployrequester.service;

import com.myself.deployrequester.dao.DeployDbserversDAO;
import com.myself.deployrequester.model.DeployDbserversDO;
import com.myself.deployrequester.model.DeployRequesterDO;
import com.myself.deployrequester.po.DeployDbserversPO;
import com.myself.deployrequester.po.DeployRequesterPO;
import com.myself.deployrequester.util.reflect.BeanUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by QueRenJie on ${date}
 */
@Service
public class DeployDbserversService {
    /** 日志 */
    private static final Logger logger = LogManager.getLogger(DeployDbserversService.class);

    @Autowired
    private DeployDbserversDAO deployDbserversDAO;

    /**
     * insert data into table t_deploy_dbservers
     *
     * @param deployDbserversDO
     * @return 1 indicates success, other values indicates failure
     */
    public int insertDeployDbservers(DeployDbserversDO deployDbserversDO) throws Exception {
        DeployDbserversPO deployDbserversPO = new DeployDbserversPO();
        BeanUtils.copyProperties(deployDbserversDO, deployDbserversPO, false);
        int successRecCount = deployDbserversDAO.insert(deployDbserversPO);
        if (successRecCount == 1) {
            deployDbserversDO.setDeploydbserversid(deployDbserversPO.getDeploydbserversid());
        }
        return successRecCount;
    }

    /**
     * 修改记录中的数据
     * @param deployDbserversDO
     * @return
     * @throws Exception
     */
    public int updateByPrimaryKeySelective(DeployDbserversDO deployDbserversDO) throws Exception {
        DeployDbserversPO deployDbserversPO = new DeployDbserversPO();
        BeanUtils.copyProperties(deployDbserversDO, deployDbserversPO, true);
        return deployDbserversDAO.updateByPrimaryKeySelective(deployDbserversPO);
    }

    /**
     * 删除指定的记录
     * @param deploydbserversid
     * @return
     * @throws Exception
     */
    public int deleteByPrimaryKey(String deploydbserversid) throws Exception {
        return deployDbserversDAO.deleteByPrimaryKey(deploydbserversid);
    }


}
