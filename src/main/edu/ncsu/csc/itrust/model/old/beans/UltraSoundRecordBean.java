package edu.ncsu.csc.itrust.model.old.beans;

/**
 * class for ultrasound record
 */
public class UltraSoundRecordBean {
    private long ultraSoundID;
    private long officeVisitID;
    private double crownRumpLength;
    private double biparietalDiameter;
    private double headCircumference;
    private double femurLength;
    private double occiFrontalDiameter;
    private double abdoCircumference;
    private double humerusLength;
    private double estimatedFetalWeight;
    private String ultraSoundImage;


    /**
     * set ultraSoundID
     * @param ultraSoundID
     */
    public void setUltraSoundID(long ultraSoundID){
        this.ultraSoundID = ultraSoundID;
    }

    /**
     * get UltraSoundID
     * @return UltraSoundID
     */
    public long getUltraSoundID(){
        return ultraSoundID;
    }

    /**
     * set officeVisitID
     * @param officeVisitID
     */
    public void setOfficeVisitID(long officeVisitID){
        this.officeVisitID = officeVisitID;
    }

    /**
     * get OfficeVisitID
     * @return OfficeVisitID
     */
    public long getOfficeVisitID(){
        return officeVisitID;
    }

    /**
     * set crownRumpLength
     * @param crownRumpLength
     */
    public void setCrownRumpLength(double crownRumpLength){
        this.crownRumpLength = crownRumpLength;
    }

    /**
     * get CrownRumpLength
     * @return CrownRumpLength
     */
    public double getCrownRumpLength(){
        return crownRumpLength;
    }

    /**
     * set biparietalDiameter
     * @param biparietalDiameter
     */
    public void setBiparietalDiameter(double biparietalDiameter){
        this.biparietalDiameter = biparietalDiameter;
    }

    /**
     * get BiparietalDiameter
     * @return BiparietalDiameter
     */
    public double getBiparietalDiameter(){
        return biparietalDiameter;
    }

    /**
     * set headCircumference
     * @param headCircumference
     */
    public void setHeadCircumference(double headCircumference){
        this.headCircumference = headCircumference;
    }

    /**
     * get HeadCircumference
     * @return HeadCircumference
     */
    public double getHeadCircumference(){
        return headCircumference;
    }

    /**
     * get FemurLength
     * @return FemurLength
     */
    public double getFemurLength(){
        return femurLength;
    }

    /**
     * set femurLength
     * @param femurLength
     */
    public void setFemurLength(double femurLength){
        this.femurLength = femurLength;
    }

    /**
     * get OcciFrontalDiameter
     * @return OcciFrontalDiameter
     */
    public double getOcciFrontalDiameter(){
        return occiFrontalDiameter;
    }

    /**
     * set occiFrontalDiameter
     * @param occiFrontalDiameter
     */
    public void setOcciFrontalDiameter(double occiFrontalDiameter){
        this.occiFrontalDiameter = occiFrontalDiameter;
    }

    /**
     * get AbdoCircumference
     * @return AbdoCircumference
     */
    public double getAbdoCircumference() {
        return abdoCircumference;
    }

    /**
     * set abdoCircumference
     * @param abdoCircumference
     */
    public void setAbdoCircumference(double abdoCircumference){
        this.abdoCircumference = abdoCircumference;
    }

    /**
     * get HumerusLength
     * @return HumerusLength
     */
    public double getHumerusLength(){
        return humerusLength;
    }

    /**
     * set humerusLength
     * @param humerusLength
     */
    public void setHumerusLength(double humerusLength){
        this.humerusLength = humerusLength;
    }

    /**
     * set estimatedFetalWeight
     * @param estimatedFetalWeight
     */
    public void setEstimatedFetalWeight(double estimatedFetalWeight){
        this.estimatedFetalWeight = estimatedFetalWeight;
    }

    /**
     * get EstimatedFetalWeight
     * @return EstimatedFetalWeight
     */
    public double getEstimatedFetalWeight(){
        return estimatedFetalWeight;
    }

    /**
     * set ultraSoundImage
     * @param ultraSoundImage
     */
    public void setUltraSoundImage(String ultraSoundImage){
        this.ultraSoundImage = ultraSoundImage;
    }

    /**
     * get UltraSoundImage
     * @return UltraSoundImage
     */
    public String getUltraSoundImage(){
        return ultraSoundImage;
    }

    /**
     * Returns true if both id's are equal. Probably needs more advance field by field checking.
     */
    @Override public boolean equals(Object other) {

        if ( this == other ){
            return true;
        }

        if ( !(other instanceof UltraSoundRecordBean) ){
            return false;
        }

        UltraSoundRecordBean otherUltrasoundRecord = (UltraSoundRecordBean)other;
        return otherUltrasoundRecord.getUltraSoundID() == getUltraSoundID();

    }
}
