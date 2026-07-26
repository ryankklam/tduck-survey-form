package com.tduck.cloud.common.util;

import javax.sql.DataSource;
import java.sql.SQLException;

public class DbDialectUtils {

    private static volatile String dbType;

    private static String detectDbType() {
        if (dbType != null) {
            return dbType;
        }
        synchronized (DbDialectUtils.class) {
            if (dbType != null) {
                return dbType;
            }
            try {
                DataSource dataSource = SpringContextUtils.getBean(DataSource.class);
                String url = dataSource.getConnection().getMetaData().getURL();
                if (url != null && url.startsWith("jdbc:postgresql:")) {
                    dbType = "postgresql";
                } else {
                    dbType = "mysql";
                }
            } catch (Exception e) {
                dbType = "mysql";
            }
            return dbType;
        }
    }

    public static boolean isPostgresql() {
        return "postgresql".equals(detectDbType());
    }

    public static String dateFormat(String column, String pattern) {
        if (isPostgresql()) {
            String pgPattern = pattern
                    .replace("%Y", "YYYY")
                    .replace("%y", "YY")
                    .replace("%m", "MM")
                    .replace("%d", "DD")
                    .replace("%H", "HH24")
                    .replace("%i", "MI")
                    .replace("%s", "SS");
            return "to_char(" + column + ", '" + pgPattern + "')";
        }
        return "date_format(" + column + ",'" + pattern + "')";
    }

    public static String yearWeekNow() {
        if (isPostgresql()) {
            return "date_trunc('week', CURRENT_DATE)";
        }
        return "YEARWEEK(now())";
    }

    public static String now() {
        return "now()";
    }

    public static void reset() {
        dbType = null;
    }
}
