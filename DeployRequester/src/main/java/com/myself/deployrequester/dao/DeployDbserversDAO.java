package com.myself.deployrequester.dao;

import com.myself.deployrequester.po.DeployDbserversPO;

public interface DeployDbserversDAO {
    int deleteByPrimaryKey(String deploydbserversid);

    int insert(DeployDbserversPO record);

    int insertSelective(DeployDbserversPO record);

    DeployDbserversPO selectByPrimaryKey(String deploydbserversid);

    int updateByPrimaryKeySelective(DeployDbserversPO record);

    int updateByPrimaryKey(DeployDbserversPO record);
}