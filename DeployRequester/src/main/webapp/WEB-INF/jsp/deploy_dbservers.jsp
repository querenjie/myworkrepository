<%--
  Created by IntelliJ IDEA.
  User: suneee
  Date: 2017/10/23
  Time: 18:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <title>数据库连接配置页面</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%=basePath%>resources/core/css/remodal.css">
    <link rel="stylesheet" href="<%=basePath%>resources/core/css/remodal-default-theme.css">
    <style>
        .remodal-bg.with-red-theme.remodal-is-opening,
        .remodal-bg.with-red-theme.remodal-is-opened {
            filter: none;
        }

        .remodal-overlay.with-red-theme {
            background-color: #f44336;
        }

        .remodal.with-red-theme {
            background: #fff;
        }

        .remodal-overlay.without-animation.remodal-is-opening,
        .remodal-overlay.without-animation.remodal-is-closing,
        .remodal.without-animation.remodal-is-opening,
        .remodal.without-animation.remodal-is-closing,
        .remodal-bg.without-animation.remodal-is-opening,
        .remodal-bg.without-animation.remodal-is-closing {
            animation: none;
        }

        .table-td-borderline table td{border:1px solid #F00}
        /* css注释：只对table td标签设置红色边框样式 */
    </style>
    <script src="<%=basePath%>resources/core/js/jquery.js"></script>
    <script src="<%=basePath%>resources/core/js/remodal/remodal.js"></script>
    <script src="<%=basePath%>resources/core/js/remodal/remodal_test.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#btnSave").click(
                function() {
                    saveData();
                }
            );

            setInterval("doRetrieveMsg()", 3000);
        });

        function saveData() {
            var belong = $("#belong").val();
            var ip = $("#ip").val();
            var port = $("#port").val();
            var username = $("#username").val();
            var password = $("#password").val();
            var needrecpwd = $('input[name="needrecpwd"]:checked').val();

            var errorMsg = "";
            if ($.trim(ip) == "") {
                errorMsg += "数据库服务器的ip不能为空！" + "\n";
            } else if (!checkIp(ip)) {
                errorMsg += "数据库服务器的ip必须要符合ip4的规则！" + "\n";
            }
            if ($.trim(port) == "") {
                errorMsg += "端口不能为空！" + "\n";
            } else if (!checkPort(port)) {
                errorMsg += "端口必须遵循计算机端口的格式和范围（0到2^16）！" + "\n";
            }
            if (errorMsg != "") {
                alert(errorMsg);
                return;
            }

            var str = "belong=" + belong + "\n";
            str += "ip=" + ip + "\n";
            str += "port=" + port + "\n";
            str += "username=" + username + "\n";
            str += "password=" + password + "\n";
            str += "needrecpwd=" + needrecpwd + "\n";
            alert(str);
        }

        function checkIp(ip) {
            var regexp = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
            var valid = regexp.test(ip);
            if (!valid) {//首先必须是 xxx.xxx.xxx.xxx 类型的数字，如果不是，返回false
                return false;
            }
            ip.split('.').every(function(num){
                //切割开来，每个都做对比，可以为0，可以小于等于255，但是不可以0开头的俩位数
                //只要有一个不符合就返回false
                if(num.length > 1 && num.charAt(0) === '0'){
                    //大于1位的，开头都不可以是‘0’
                    return false;
                }else if(parseInt(num , 10) > 255){
                    //大于255的不能通过
                    return false;
                }
                return true;
            });
        }

        function checkPort(port) {
            var regexp = /^\d{1,5}$/;
            var valid = regexp.test(port);
            if (!valid) {
                return false;
            }
            if (port.length > 1 && port.charAt(0) === '0') {
                return false;
            } else if (parseInt(port) > 256 * 256) {
                return false;
            }
            return true;
        }

        function doRetrieveMsg() {
            retrieveNotice();
            retrieveSpeech();
        }

        function retrieveNotice() {
            $.ajax({
                type: "POST",
                url: "<%=basePath%>noticeboard/getnotice",
                data:"",//json序列化
                datatype:"json", //此处不能省略
                contentType: "application/json; charset=utf-8",//此处不能省略
                success:function(resultData){
                    $("#serverStatus").html("");
                    if (resultData != null) {
                        if (resultData.data != null && resultData.data.length > 0) {
                            var notice = resultData.data[0].notice;
                            var refreshPage = resultData.data[0].refreshPage;
                            var delaytimeBeforeRefreshPage = resultData.data[0].delaytimeBeforeRefreshPage;
                            var describe = resultData.data[0].describe;
                            if (refreshPage == 0 && notice != "") {
                                $("#noticeContent").html(notice);
                                $("#promptDescription").html("");
                                $("#callModal").click();
                            } else if (refreshPage == 1 && (notice != "" || describe != "")) {
                                $("#noticeContent").html(notice);
                                $("#promptDescription").html(describe);
                                $("#callModal").click();
                                setTimeout("reloadPage()", delaytimeBeforeRefreshPage);
                            }
                        }
                    }
                },
                error:function(resultData){
                    //alert("发布系统停止运行，请耐心等待。。。");
                    $("#serverStatus").html("发布系统停止运行，请耐心等待。。。");
                }
            });
        }

        function retrieveSpeech() {
            $.ajax({
                type: "POST",
                url: "<%=basePath%>noticeboard/getSpeech",
                data:"",//json序列化
                datatype:"json", //此处不能省略
                contentType: "application/json; charset=utf-8",//此处不能省略
                success:function(resultData){
                    $("#serverStatus").html("");
                    if (resultData != null) {
                        if (resultData.data != null && resultData.data.length > 0) {
                            var speech = resultData.data[0];
                            var msg = "";
                            msg += speech.speaker + "在" + speech.speakTime + "给你消息:" + "\n";
                            msg += speech.speakContent;
                            alert(msg);
                        }
                    }
                },
                error:function(resultData){
                    //alert("发布系统停止运行，请耐心等待。。。");
                    $("#serverStatus").html("发布系统停止运行，请耐心等待。。。");
                }
            });
        }


    </script>
</head>
<body>
<font color="blue">建议使用chrome浏览器，在其他浏览器上运行有可能不正常。(chrome is a strong recommendation, others may cause malfunction.)</font>
<div class="remodal-bg">
    <a id="callModal" href="#" data-remodal-target="modal5" style="visibility: hidden;">Call</a>
</div>


<div class="remodal" data-remodal-id="modal5">
    <div><font id="noticeContent" size="5" color="blue"></font></div>
    <div><font id="promptDescription" size="8" color="red"></font></div>
    <a id="closemodal" data-remodal-action="close" class="remodal-close"></a>
</div>

<div id="target"></div>

<div><font color="red" id="serverStatus" size="5"></font> </div>
<table align="center" width="50%">
    <tr><td align="center"><font size="5">数据库连接配置</font></td></tr>
</table>
<table align="center" width="80%" border="1">
    <tr>
        <td><font color="red">数据库环境：</font></td>
        <td>
            <select id="belong">
                <option value="1">预发环境</option>
                <option value="2">生产环境</option>
            </select>
        </td>
        <td><font color="red">数据库服务器的ip：</font></td>
        <td><input type="text" id="ip" maxlength="15"></td>
        <td><font color="red">端口：</font> </td>
        <td><input type="text" id="port" maxlength="5"></td>
    </tr>
    <tr>
        <td><font color="red">数据库用户名：</font> </td>
        <td><input type="text" id="username" maxlength="20"></td>
        <td>密码：</td>
        <td><input type="password" id="password" maxlength="20"></td>
        <td><font color="red">是否需要记住密码：</font> </td>
        <td>
            <label>
                <input type="radio" name="needrecpwd" value="0">不记密码
                <input type="radio" name="needrecpwd" value="1" checked>让系统记住密码
            </label>
        </td>
    </tr>
    <tr>
        <td colspan="6" align="right"><input type="button" value="保存" id="btnSave"> </td>
    </tr>
</table>
</body>
</html>
