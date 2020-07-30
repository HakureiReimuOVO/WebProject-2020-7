package servlet.service;

import DAO.PhotoDAO;
import bean.Photo;
import utils.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;

@WebServlet("/DeleteService")
public class DeleteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            PhotoDAO dao = new PhotoDAO();
            String imageID = req.getParameter("id");
            Photo photo = dao.searchPhoto("SELECT * FROM travelimage WHERE ImageID = ?", imageID);
            String path = photo.getPath();
            String realPath = getServletContext().getRealPath(getServletName());
            realPath = realPath.substring(0, realPath.lastIndexOf("\\")).replace('\\','/');
            new File(realPath + "/src/images/travel-images/large/" + path).delete();
            new File(realPath + "/src/images/travel-images/medium/" + path).delete();
            new File(realPath + "/src/images/travel-images/small/" + path).delete();
            for (Cookie cookie : req.getCookies()) {
                if (cookie.getName().equals("FOOTPRINT_" + imageID)) Utils.deleteCookie(cookie, req, resp);
            }
            dao.updateDatabase("DELETE FROM travelimage WHERE ImageID = ?", imageID);
            String URL = req.getHeader("Referer");
            resp.sendRedirect(URL);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}