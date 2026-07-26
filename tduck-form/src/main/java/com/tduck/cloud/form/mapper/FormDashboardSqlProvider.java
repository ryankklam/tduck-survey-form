package com.tduck.cloud.form.mapper;

import com.tduck.cloud.common.util.DbDialectUtils;
import org.apache.ibatis.builder.annotation.ProviderContext;
import org.apache.ibatis.jdbc.SQL;

public class FormDashboardSqlProvider {

    public String selectFormReportSituation(String formKey) {
        String dateFormat = DbDialectUtils.dateFormat("create_time", "%Y-%m-%d");
        String yearWeek = DbDialectUtils.yearWeekNow();
        return new SQL() {{
            SELECT(dateFormat + " as create_time, COUNT(1) AS count");
            FROM("fm_user_form_data");
            WHERE("create_time >= " + yearWeek);
            WHERE("form_key = #{formKey}");
            GROUP_BY(dateFormat);
        }}.toString();
    }

    public String selectFormReportPosition(String formKey) {
        return "SELECT submit_address, COUNT(1) as count FROM fm_user_form_data WHERE form_key=#{formKey} GROUP BY submit_address";
    }

    public String selectFormReportDevice(String formKey) {
        return "SELECT submit_os as os_name, COUNT(1) as count FROM fm_user_form_data WHERE form_key=#{formKey} GROUP BY submit_os";
    }

    public String selectFormReportSource(String formKey) {
        return "SELECT submit_browser as browser_name, COUNT(1) as count FROM fm_user_form_data WHERE form_key=#{formKey} GROUP BY submit_browser";
    }
}
