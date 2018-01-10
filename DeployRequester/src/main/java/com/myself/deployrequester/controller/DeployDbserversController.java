package com.myself.deployrequester.controller;

import com.myself.deployrequester.service.DeployDbserversService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by QueRenJie on ${date}
 */
@Controller
@RequestMapping("depdbservers")
public class DeployDbserversController {
    @Autowired
    private DeployDbserversService deployDbserversService;

    @RequestMapping("/deploy_dbservers")
    public String gotoDbserversConfigForm() {
        return "deploy_dbservers";
    }

}
