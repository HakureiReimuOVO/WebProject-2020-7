package servlet.viewer;

import DAO.PhotoDAO;
import bean.Photo;
import bean.User;
import utils.Utils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/details")
public class Details extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            PhotoDAO photoDAO = new PhotoDAO();
            String imageID = req.getParameter("id");
            req.getSession().setAttribute("LastPage", req.getContextPath() + "/details?id=" + imageID);
            Photo photo = photoDAO.searchPhoto("SELECT * FROM travelimage WHERE ImageID = ?", imageID);
            photo.setFavorNumber(Utils.getFavorNumber(photoDAO, photo.getImageID()));
            photo.setUserName(Utils.getUserName(photoDAO, photo.getUID()));
            photo.setCityName(Utils.getCityName(photoDAO, photo.getCityCode()));
            photo.setCountryName(Utils.getCountryName(photoDAO, photo.getCountryCode()));
            Cookie cookie = new Cookie("FOOTPRINT_" + imageID, photo.getPath() + "_" + URLEncoder.encode(photo.getTitle()));
            addFootprint(req, resp, cookie);
            req.setAttribute("Photo", photo);
            if (req.getSession().getAttribute("User") != null) {
                User user = (User) req.getSession().getAttribute("User");
                Map<String, Object> result = photoDAO.searchResult("SELECT * FROM travelimagefavor WHERE UID = ? AND ImageID = ?", user.getUID(), imageID);
                req.setAttribute("IfFavor", !result.isEmpty());
            }
            req.getRequestDispatcher("/pages/details.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void addFootprint(HttpServletRequest req, HttpServletResponse resp, Cookie footprint) {
        Cookie[] cookies = req.getCookies();
        Cookie tempCookie = null;
        List<Cookie> footprints = new ArrayList<>();
        if (cookies.length > 0) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().startsWith("FOOTPRINT_")) {
                    footprints.add(cookie);
                    if (cookie.getName().substring(10).equals(footprint.getName().substring(10))) {
                        tempCookie = cookie;
                    }
                }
            }
            if (tempCookie == null && footprints.size() >= 10) {
                tempCookie = footprints.get(0);
            }
        }
        if (tempCookie != null) Utils.deleteCookie(tempCookie, req, resp);
        resp.addCookie(footprint);
    }
}
