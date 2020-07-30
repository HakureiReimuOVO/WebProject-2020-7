package utils;

import DAO.DAO;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {
    public static Timestamp getCurrentTimestamp() {
        Date date = new Date();
        Timestamp timeStamp = new Timestamp(date.getTime());
        return timeStamp;
    }

    public static String modifyTimestamp(Timestamp timestamp, String format) {
        DateFormat dateFormat = new SimpleDateFormat(format);
        return dateFormat.format(timestamp);
    }

    public static String getUserName(DAO dao, int UID) throws SQLException {
        String UserName = dao.searchItem("SELECT UserName FROM traveluser WHERE UID = ?", UID);
        return UserName;
    }

    public static String getCityName(DAO dao, int cityCode) throws SQLException {
        String cityName = dao.searchItem("SELECT AsciiName FROM geocities WHERE GeoNameID = ?", cityCode);
        return (cityName == null) ? "Unknown" : cityName;
    }

    public static String getCountryName(DAO dao, String countryCode) throws SQLException {
        String countryName = dao.searchItem("SELECT Country_RegionName FROM geocountries_regions WHERE ISO = ?", countryCode);
        return (countryName == null) ? "Unknown" : countryName;
    }

    public static int getCityCode(DAO dao, String cityName) throws SQLException {
        int cityCode = dao.searchItem("SELECT GeoNameID FROM geocities WHERE AsciiName = ?", cityName);
        return cityCode;
    }

    public static String getCountryCode(DAO dao, String countryName) throws SQLException {
        String countryCode = dao.searchItem("SELECT ISO FROM geocountries_regions WHERE Country_RegionName = ?", countryName);
        return countryCode;
    }

    public static int getFavorNumber(DAO dao, int imageID) throws SQLException {
        long favorNumber = dao.searchItem("SELECT Count(1) FROM travelimagefavor WHERE ImageID = ?", imageID);
        return (int) favorNumber;
    }

    public static void deleteCookie(Cookie cookie, HttpServletRequest request, HttpServletResponse response) {
        cookie.setMaxAge(0);
        cookie.setDomain(request.getServerName());
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);
    }

    public static int[] getStartEndPage(int currentPage, int totalPage) {
        int extraStartPage;
        int extraEndPage;
        int startPage;
        int endPage;
        if (totalPage > 5) {
            extraStartPage = currentPage - totalPage + 2;
            extraEndPage = 3 - currentPage;
            endPage = (extraStartPage > 0) ? totalPage : currentPage + 2;
            startPage = (extraEndPage > 0) ? 1 : (currentPage - 2);
            endPage += (extraEndPage > 0) ? extraEndPage : 0;
            startPage -= (extraStartPage > 0) ? extraStartPage : 0;
        } else {
            startPage = 1;
            endPage = totalPage;
        }
        return new int[]{startPage, endPage};
    }
}
