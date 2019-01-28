package edu.ncsu.csc.itrust.action;


import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.PatientBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;

import java.sql.SQLException;

import edu.ncsu.csc.itrust.exception.DBException;

import edu.ncsu.csc.itrust.action.SearchUsersAction;
import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.PregnancyDAO;
import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.ObstetricsInitRecordDAO;
import edu.ncsu.csc.itrust.model.old.beans.loaders.ObstetricsInitRecordBeanLoader;
import edu.ncsu.csc.itrust.model.old.beans.loaders.PregnancyBeanLoader;

import edu.ncsu.csc.itrust.model.old.validate.ObstetricsInitRecordBeanValidator;
import edu.ncsu.csc.itrust.model.old.validate.PregnancyBeanValidator;



public class ObstetricHistoryAction {
    private ObstetricsInitRecordDAO obstetricsInitRecordDAO;
    private PregnancyDAO pregnancyDAO;

    public ObstetricHistoryAction(DAOFactory factory) {
        this.obstetricsInitRecordDAO = factory.getObstetricsInitRecordDAO();
        this.pregnancyDAO = factory.getPregnancyDAO();
    }

    /**
     * Takes in patient MID chosen by OB/GYN hcp's from the front end and return
     * a list of all obstetric history Bean object of that patient
     * @param mid
     * @return
     */
    public List<ObstetricsInitRecordBean> getPatientObstericsInitRecords(long mid) {
        try {
            List<ObstetricsInitRecordBean> result = obstetricsInitRecordDAO.getAllObstetricsInitRecord(mid);
            return result;
        } catch (DBException e) {
            return null;
        }
    }

    /**
     * Takes in patient MID chosen by hcps from the fron end and return a list of all pregnancy Bean object of that patient
     * @param mid
     * @return
     */
    public List<PregnancyBean> getAllPregnancy(long mid) {
        try {
            List<PregnancyBean> result = pregnancyDAO.getAllPregnancy(mid);
            return result;
        } catch (DBException e) {
            return null;
        }
    }


    public int initializationObstetricRecord(String mid, String LMP, String EDD, String weeksPreg) {
        ObstetricsInitRecordBean obstetricsInitRecordBean = new ObstetricsInitRecordBean();
        obstetricsInitRecordBean.setMID(Long.parseLong(mid));
        obstetricsInitRecordBean.setEDD(EDD);
        obstetricsInitRecordBean.setLMP(LMP);
        obstetricsInitRecordBean.setWeeksOfPregnant(weeksPreg);
        ObstetricsInitRecordBeanValidator validator = new ObstetricsInitRecordBeanValidator();
        try {
            validator.validate(obstetricsInitRecordBean);
        } catch (FormValidationException e) {
            System.out.println("Invalid input for obstetric care intialization");
            System.out.println("The error is:\n" + e);
            return -1;
        }

        try {
            obstetricsInitRecordDAO.addObstetricsInitRecord(obstetricsInitRecordBean);
            return 1;
        } catch (DBException e) {
            System.out.println("Could not add data into obstetrics initialization record!");
            return -1;
        }
    }


    public int addPregnancyInformation(String mid, String yearOfConception, String weeksOfPregnant, String hoursInLabor, String weightGain, String deliveryType, String pregnancyNumber) {

        PregnancyBean pregnancyBean = new PregnancyBean();
        pregnancyBean.setMID(Long.parseLong(mid));
        pregnancyBean.setYearOfConception(Integer.parseInt(yearOfConception));
        pregnancyBean.setWeeksOfPregnant(weeksOfPregnant);
        pregnancyBean.setHoursInLabor(Double.parseDouble(hoursInLabor));
        pregnancyBean.setWeightGain(Double.parseDouble(weightGain));
        pregnancyBean.setDeliveryType(deliveryType);
        pregnancyBean.setPregnancyNumber(Integer.parseInt(pregnancyNumber));


        PregnancyBeanValidator validator = new PregnancyBeanValidator();
        try {
            validator.validate(pregnancyBean);
        } catch (FormValidationException e) {
            System.out.println("Invalid input for pregnancy data!");
            System.out.println(e);
            return -1;
        }

        try {
            pregnancyDAO.addPregnancy(pregnancyBean);
            return 1;
        } catch (DBException e) {
            System.out.println("Could not add data into patient's pregnancy record!");
            return -1;
        }
    }

}
