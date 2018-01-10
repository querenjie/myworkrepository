package com.myself.deployrequester.service;

import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Created by QueRenJie on ${date}
 */
@Service
public class DeployDBScriptService {
    public static void main(String[] args) {
        try{
            Class.forName("org.postgresql.Driver").newInstance();
            String connectUrl ="jdbc:postgresql://172.19.14.200:5432/DeployRequester";
            Connection conn = DriverManager.getConnection(connectUrl, "postgres", "postgres");
            conn.setAutoCommit(false);
            Statement st = conn.createStatement();
            st.clearBatch();

            String sql = "SELECT count(*) FROM t_deploy_prodenv1";
            ResultSet rs = st.executeQuery(sql);
            while(rs.next()){
                System.out.println(rs.getInt(1));
            }
            rs.close();
            st.close();
            conn.close();
        }catch(Exception e){
            System.out.println(e);
        }
    }


}
