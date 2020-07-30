package servlet.viewer;

import DAO.PhotoDAO;
import bean.Photo;
import bean.User;
import utils.Utils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/photo")
public class UserPhoto extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getSession().getAttribute("User") != null) {
                int pageSize = 5;
                req.getSession().setAttribute("LastPage", req.getContextPath() + "/photo");
                PhotoDAO photoDAO = new PhotoDAO();
                User user = (User) req.getSession().getAttribute("User");
                List<Photo> photos = photoDAO.searchPhotos("SELECT * FROM travelimage WHERE UID = ?", user.getUID());
                int totalPage = ((photos.size() - 1) / pageSize) + 1;
                int currentPage = 1;
                int[] startEndPage = Utils.getStartEndPage(currentPage, totalPage);
                String ajaxStatement = "uid=" + user.getUID() + "&totalPage=" + totalPage + "&";
                req.setAttribute("Photos", photos.subList(0, Math.min(pageSize, photos.size())));
                req.setAttribute("AjaxStatement", ajaxStatement);
                req.setAttribute("CurrentPage", currentPage);
                req.setAttribute("TotalPage", totalPage);
                req.setAttribute("StartPage", startEndPage[0]);
                req.setAttribute("EndPage", startEndPage[1]);
                req.getRequestDispatcher("/pages/photo.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/index");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getSession().getAttribute("User") != null) {
                int pageSize = 5;
                int currentPage = Integer.parseInt(req.getParameter("page"));
                int totalPage = Integer.parseInt(req.getParameter("totalPage"));
                int[] startEndPage = Utils.getStartEndPage(currentPage, totalPage);
                req.getSession().setAttribute("LastPage", req.getContextPath() + "/photo");
                PhotoDAO photoDAO = new PhotoDAO();
                User user = (User) req.getSession().getAttribute("User");
                List<Photo> photos = photoDAO.searchPhotos("SELECT * FROM travelimage WHERE UID = ? LIMIT ?, ?",
                        user.getUID(), (currentPage - 1) * pageSize, pageSize);
                req.setAttribute("Photos", photos);
                req.setAttribute("CurrentPage", currentPage);
                req.setAttribute("TotalPage", totalPage);
                req.setAttribute("StartPage", startEndPage[0]);
                req.setAttribute("EndPage", startEndPage[1]);
                req.getRequestDispatcher("/ajax/photoAjax.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/index");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}