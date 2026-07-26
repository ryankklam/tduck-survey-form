package com.tduck.cloud.api.config;

import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.sql.SQLException;

/**
 * @author smalljop
 * @description mybaits plus 配置文件
 * @create 2019-12-10 16:28
 **/
@EnableTransactionManagement
@Configuration
@MapperScan("com.tduck.cloud.**.mapper")
public class MybatisPlusConfig {

    private final DataSource dataSource;

    public MybatisPlusConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        String dbType = detectDbType();
        if ("postgresql".equals(dbType)) {
            interceptor.addInnerInterceptor(new PaginationInnerInterceptor(com.baomidou.mybatisplus.annotation.DbType.POSTGRE_SQL));
        } else {
            interceptor.addInnerInterceptor(new PaginationInnerInterceptor(com.baomidou.mybatisplus.annotation.DbType.MYSQL));
        }
        return interceptor;
    }

    private String detectDbType() {
        try {
            String url = dataSource.getConnection().getMetaData().getURL();
            if (url != null && url.startsWith("jdbc:postgresql:")) {
                return "postgresql";
            }
        } catch (SQLException ignored) {
        }
        return "mysql";
    }

}
