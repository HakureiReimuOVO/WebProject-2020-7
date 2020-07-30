package servlet.service;

import DAO.PhotoDAO;
import bean.Photo;
import net.coobird.thumbnailator.Thumbnails;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import utils.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/ModifyService")
public class ModifyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            PhotoDAO dao = new PhotoDAO();
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> fileItems = upload.parseRequest(req);
            String newPath = "" + System.currentTimeMillis() / 1000 + ".jpg";
            String countryName = null;
            String cityName = null;
            String title = null;
            String description = null;
            String content = null;
            String imageID = null;
            boolean ifModifyPhoto = false;
            Timestamp date = Utils.getCurrentTimestamp();
            for (FileItem fileItem : fileItems) {
                switch (fileItem.getFieldName()) {
                    case "title":
                        title = fileItem.getString();
                        break;
                    case "description":
                        description = fileItem.getString();
                        break;
                    case "content":
                        content = fileItem.getString();
                        break;
                    case "country":
                        countryName = fileItem.getString();
                        break;
                    case "city":
                        cityName = fileItem.getString();
                        break;
                    case "id":
                        imageID = fileItem.getString();
                        break;
                    case "photo":
                        if (!fileItem.getContentType().equals("application/octet-stream")) {
                            ifModifyPhoto = true;
                            Photo photo = dao.searchPhoto("SELECT * FROM travelimage WHERE ImageID = ?", imageID);
                            String realPath = getServletContext().getRealPath(getServletName());
                            realPath = realPath.substring(0, realPath.lastIndexOf("\\")).replace('\\','/');
                            String path = photo.getPath();
                            new File(realPath + "/src/images/travel-images/large/" + path).delete();
                            new File(realPath + "/src/images/travel-images/medium/" + path).delete();
                            new File(realPath + "/src/images/travel-images/small/" + path).delete();
                            File photoFile = new File(realPath + "/src/images/travel-images/large/" + newPath);
                            fileItem.write(photoFile);
                            Thumbnails.of(photoFile).scale(0.5f).toFile(realPath + "/src/images/travel-images/medium/" + newPath);
                            Thumbnails.of(photoFile).scale(0.25f).toFile(realPath + "/src/images/travel-images/small/" + newPath);
                        }
                }
            }
            String country = Utils.getCountryCode(dao, countryName);
            int city = Utils.getCityCode(dao, cityName);
            if (ifModifyPhoto) {
                dao.updateDatabase("UPDATE travelimage SET Title = ?, Description = ?, CityCode = ?, CountryCode = ?, " +
                        "Content = ?, Path = ?, DateLastModified = ? WHERE ImageID = ?", title, description, city, country, content, newPath, date, imageID);
                for (Cookie cookie : req.getCookies()) {
                    if (cookie.getName().equals("FOOTPRINT_" + imageID)) {
                        cookie.setValue(newPath + "_" + URLEncoder.encode(title));
                        resp.addCookie(cookie);
                    }
                }
            } else {
                dao.updateDatabase("UPDATE travelimage SET Title = ?, Description = ?, CityCode = ?, CountryCode = ?, " +
                        "Content = ?, DateLastModified = ? WHERE ImageID = ?", title, description, city, country, content, date, imageID);
                for (Cookie cookie : req.getCookies()) {
                    if (cookie.getName().equals("FOOTPRINT_" + imageID)) {
                        cookie.setValue(cookie.getValue().substring(0, cookie.getValue().indexOf('_')) + "_" + URLEncoder.encode(title));
                        resp.addCookie(cookie);
                    }
                }
            }
            resp.sendRedirect(req.getContextPath() + "/photo");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}