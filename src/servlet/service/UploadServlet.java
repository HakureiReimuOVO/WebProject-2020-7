package servlet.service;

import DAO.DAO;
import bean.User;
import net.coobird.thumbnailator.Thumbnails;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import utils.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/UploadService")
public class UploadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            DAO dao = new DAO();
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> fileItems = upload.parseRequest(req);
            String realPath = getServletContext().getRealPath(getServletName());
            realPath = realPath.substring(0, realPath.lastIndexOf("\\")).replace('\\','/');
            String path = "" + System.currentTimeMillis() / 1000 + ".jpg";
            File photoFile = new File(realPath + "/src/images/travel-images/large/" + path);
            String countryName = null;
            String cityName = null;
            String title = null;
            String description = null;
            String content = null;
            Timestamp date = Utils.getCurrentTimestamp();
            int UID = ((User) req.getSession().getAttribute("User")).getUID();
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
                    case "photo":
                        fileItem.write(photoFile);
                }
            }
            Thumbnails.of(photoFile).scale(0.5f).toFile(realPath + "/src/images/travel-images/medium/" + path);
            Thumbnails.of(photoFile).scale(0.25f).toFile(realPath + "/src/images/travel-images/small/" + path);
            String country = Utils.getCountryCode(dao, countryName);
            int city = Utils.getCityCode(dao, cityName);
            dao.updateDatabase("INSERT INTO travelimage (Title, Description, CityCode, CountryCode, UID, Path, Content, DateUploaded, DateLastModified) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", title, description, city, country, UID, path, content, date, date);
            resp.sendRedirect(req.getContextPath() + "/photo");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}