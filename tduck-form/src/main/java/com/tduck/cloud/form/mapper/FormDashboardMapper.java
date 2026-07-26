package com.tduck.cloud.form.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tduck.cloud.form.entity.UserFormDataEntity;
import com.tduck.cloud.form.vo.FormReportVO;
import com.tduck.cloud.form.vo.SituationVO;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.SelectProvider;

import java.util.List;
import java.util.Set;

public interface FormDashboardMapper extends BaseMapper<UserFormDataEntity> {

    @SelectProvider(type = FormDashboardSqlProvider.class, method = "selectFormReportSituation")
    Set<SituationVO> selectFormReportSituation(@Param("formKey") String formKey);

    @SelectProvider(type = FormDashboardSqlProvider.class, method = "selectFormReportPosition")
    List<FormReportVO.Position> selectFormReportPosition(String formKey);

    @SelectProvider(type = FormDashboardSqlProvider.class, method = "selectFormReportDevice")
    List<FormReportVO.Device> selectFormReportDevice(String formKey);

    @SelectProvider(type = FormDashboardSqlProvider.class, method = "selectFormReportSource")
    List<FormReportVO.Source> selectFormReportSource(String formKey);
}
