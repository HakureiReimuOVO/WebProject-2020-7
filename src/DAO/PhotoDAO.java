package DAO;

import bean.Photo;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class PhotoDAO extends DAO {

    public PhotoDAO() throws SQLException {

    }

    public Photo searchPhoto(String sql, Object... args) throws SQLException {
        Map<String, Object> result = super.searchResult(sql, args);
        Photo photo = getPhotoByMap(result);
        return photo;
    }

    public List<Photo> searchPhotos(String sql, Object... args) throws SQLException {
        List<Map<String, Object>> results = super.searchResults(sql, args);
        List<Photo> photos = new ArrayList<>();
        for (Map<String, Object> result : results) {
            photos.add(getPhotoByMap(result));
        }
        return photos;
    }

    private Photo getPhotoByMap(Map<String, Object> result) throws SQLException {
        Photo photo = new Photo();
        if (result.get("ImageID") != null) photo.setImageID((int) result.get("ImageID"));
        if (result.get("UID") != null) photo.setUID((int) result.get("UID"));
        if (result.get("Title") != null) photo.setTitle((String) result.get("Title"));
        if (result.get("Description") != null && !result.get("Description").equals(""))
            photo.setDescription((String) result.get("Description"));
        else photo.setDescription("No Description");
        if (result.get("CityCode") != null) photo.setCityCode((int) result.get("CityCode"));
        if (result.get("CountryCode") != null) photo.setCountryCode((String) result.get("CountryCode"));
        if (result.get("Path") != null) photo.setPath((String) result.get("Path"));
        if (result.get("Content") != null) photo.setContent((String) result.get("Content"));
        if (result.get("DateUploaded") != null) photo.setDateUploaded((Timestamp) result.get("DateUploaded"));
        if (result.get("DateLastModified") != null)
            photo.setDateLastModified((Timestamp) result.get("DateLastModified"));
        return photo;
    }
}
