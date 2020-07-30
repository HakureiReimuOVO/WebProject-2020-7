package bean;

import java.sql.Timestamp;

public class Photo {
    private int imageID;
    private int UID;
    private int cityCode;
    private int favorNumber;
    private String cityName;
    private String countryName;
    private String userName;
    private String title;
    private String description;
    private String countryCode;
    private String path;
    private String content;
    private Timestamp dateUploaded;
    private Timestamp dateLastModified;

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public int getUID() {
        return UID;
    }

    public void setUID(int UID) {
        this.UID = UID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCityCode() {
        return cityCode;
    }

    public void setCityCode(int cityCode) {
        this.cityCode = cityCode;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public int getFavorNumber() {
        return favorNumber;
    }

    public void setFavorNumber(int favorNumber) {
        this.favorNumber = favorNumber;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getDateUploaded() {
        return dateUploaded;
    }

    public void setDateUploaded(Timestamp dateUploaded) {
        this.dateUploaded = dateUploaded;
    }

    public Timestamp getDateLastModified() {
        return dateLastModified;
    }

    public void setDateLastModified(Timestamp dateLastModified) {
        this.dateLastModified = dateLastModified;
    }

    @Override
    public String toString() {
        return "[ImageID=" + imageID +
                ";UID=" + UID +
                ";Title=" + title +
                ";Description=" + description +
                ";CityCode=" + cityCode +
                ";CountryCode=" + countryCode +
                ";Path=" + path +
                ";Content=" + content +
                ";DateUploaded=" + dateUploaded +
                ";DateLastModified=" + dateLastModified + "]";
    }
}
