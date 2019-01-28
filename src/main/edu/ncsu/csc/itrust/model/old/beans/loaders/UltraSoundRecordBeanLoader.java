package edu.ncsu.csc.itrust.model.old.beans.loaders;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import edu.ncsu.csc.itrust.model.old.beans.UltraSoundRecordBean;


public class UltraSoundRecordBeanLoader implements BeanLoader<UltraSoundRecordBean> {
    /**
     * load a list of ultrasoundrecordbean obejcts
     * @param rs The java.sql.ResultSet we are extracting.
     * @return
     * @throws SQLException
     */
    @Override
    public List<UltraSoundRecordBean> loadList(ResultSet rs) throws SQLException {
        List<UltraSoundRecordBean> list = new ArrayList<UltraSoundRecordBean>();
        while(rs.next()){
            list.add(loadSingle(rs));
        }
        return list;
    }

    /**
     * load a single ultrasoundrecord object
     * @param rs The java.sql.ResultSet to be loaded.
     * @return
     * @throws SQLException
     */
    @Override
    public UltraSoundRecordBean loadSingle(ResultSet rs) throws SQLException {
        UltraSoundRecordBean ultraSoundRecordBean = new UltraSoundRecordBean();
        ultraSoundRecordBean.setUltraSoundID(rs.getLong("id"));
        ultraSoundRecordBean.setOfficeVisitID(rs.getLong("officeVisitRecordID"));
        ultraSoundRecordBean.setCrownRumpLength(rs.getDouble("crownRumpLength"));
        ultraSoundRecordBean.setBiparietalDiameter(rs.getDouble("biparietalDiameter"));
        ultraSoundRecordBean.setHeadCircumference(rs.getDouble("headCircumference"));
        ultraSoundRecordBean.setFemurLength(rs.getDouble("femurLength"));
        ultraSoundRecordBean.setOcciFrontalDiameter(rs.getDouble("occiFrontalDiameter"));
        ultraSoundRecordBean.setAbdoCircumference(rs.getDouble("abdoCircumference"));
        ultraSoundRecordBean.setHumerusLength(rs.getDouble("humerusLength"));
        ultraSoundRecordBean.setEstimatedFetalWeight(rs.getDouble("estimatedFetalWeight"));
        ultraSoundRecordBean.setUltraSoundImage(rs.getString("ultraSoundImage"));
        return ultraSoundRecordBean;
    }

    /**
     * pass the value of a ultrasoundrecord bean object to prepared statement
     * @param ps The prepared statement to be loaded.
     * @param bean The bean containing the data to be placed.
     * @return
     * @throws SQLException
     */
    @Override
    public PreparedStatement loadParameters(PreparedStatement ps, UltraSoundRecordBean bean) throws SQLException{
        ps.setLong(1,bean.getUltraSoundID());
        ps.setLong(2, bean.getOfficeVisitID());
        ps.setDouble(3, bean.getCrownRumpLength());
        ps.setDouble(4, bean.getBiparietalDiameter());
        ps.setDouble(5, bean.getHeadCircumference());
        ps.setDouble(6, bean.getFemurLength());
        ps.setDouble(7, bean.getOcciFrontalDiameter());
        ps.setDouble(8, bean.getAbdoCircumference());
        ps.setDouble(9, bean.getHumerusLength());
        ps.setDouble(10, bean.getEstimatedFetalWeight());
        ps.setString(11, bean.getUltraSoundImage());
        return ps;
    }
}
