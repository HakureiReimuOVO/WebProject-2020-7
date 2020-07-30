package bean;

import java.sql.Timestamp;

public class User {
    private int UID;
    private String userName;
    private String email;
    private String password;
    private Timestamp dateJoined;
    private Timestamp dateLastModified;
    private boolean ifHideFavor;

    public int getUID() {
        return UID;
    }

    public void setUID(int UID) {
        this.UID = UID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Timestamp getDateJoined() {
        return dateJoined;
    }

    public void setDateJoined(Timestamp dateJoined) {
        this.dateJoined = dateJoined;
    }

    public Timestamp getDateLastModified() {
        return dateLastModified;
    }

    public void setDateLastModified(Timestamp dateLastModified) {
        this.dateLastModified = dateLastModified;
    }

    public boolean isIfHideFavor() {
        return ifHideFavor;
    }

    public void setIfHideFavor(boolean ifHideFavor) {
        this.ifHideFavor = ifHideFavor;
    }

    @Override
    public String toString() {
        return "[UID=" + UID +
                ";UserName=" + userName +
                ";Email=" + email +
                ";Password=" + password +
                ";DateJoined=" + dateJoined +
                ";DateLastModified=" + dateLastModified +
                ";IfHideFavor=" + ifHideFavor + "]";
    }
}
