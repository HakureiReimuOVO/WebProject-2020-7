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

@WebServlet("/favor")
public class UserFavor extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getSession().getAttribute("User") != null) {
                int pageSize = 5;
                req.getSession().setAttribute("LastPage", req.getContextPath() + "/favor");
                PhotoDAO photoDAO = new PhotoDAO();
                User user = (User) req.getSession().getAttribute("User");
                List<Photo> photos = photoDAO.searchPhotos("SELECT * FROM travelimage LEFT JOIN (SELECT ImageID FROM travelimagefavor WHERE UID = ?) " +
                        "AS tb ON tb.ImageID = travelimage.ImageID WHERE travelimage.ImageID = tb.ImageID", user.getUID());
                int totalPage = ((photos.size() - 1) / pageSize) + 1;
                int currentPage = 1;
                int[] startEndPage = Utils.getStartEndPage(currentPage, totalPage);
                String ajaxStatement = "uid=" + user.getUID() + "&totalPage=" + totalPage + "&ifFriend=false&";
                req.setAttribute("Photos", photos.subList(0, Math.min(pageSize, photos.size())));
                req.setAttribute("AjaxStatement", ajaxStatement);
                req.setAttribute("CurrentPage", currentPage);
                req.setAttribute("TotalPage", totalPage);
                req.setAttribute("StartPage", startEndPage[0]);
                req.setAttribute("EndPage", startEndPage[1]);
                req.getRequestDispatcher("/pages/favor.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/index");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int pageSize = 5;
            PhotoDAO photoDAO = new PhotoDAO();
            if (req.getParameter("page") != null) {
                int currentPage = Integer.parseInt(req.getParameter("page"));
                int totalPage = Integer.parseInt(req.getParameter("totalPage"));
                int[] startEndPage = Utils.getStartEndPage(currentPage, totalPage);
                List<Photo> photos = photoDAO.searchPhotos("SELECT * FROM travelimage LEFT JOIN (SELECT ImageID FROM travelimagefavor WHERE UID = ?) " +
                                "AS tb ON tb.ImageID = travelimage.ImageID WHERE travelimage.ImageID = tb.ImageID LIMIT ?, ?",
                        req.getParameter("uid"), (currentPage - 1) * pageSize, pageSize);
                req.setAttribute("Photos", photos);
                req.setAttribute("CurrentPage", currentPage);
                req.setAttribute("TotalPage", totalPage);
                req.setAttribute("StartPage", startEndPage[0]);
                req.setAttribute("EndPage", startEndPage[1]);
                req.setAttribute("ifFriend", req.getParameter("ifFriend"));
                req.getRequestDispatcher("/ajax/favorAjax.jsp").forward(req, resp);
            } else {
                req.getSession().setAttribute("LastPage", req.getContextPath() + "/favor");
                List<Photo> photos = photoDAO.searchPhotos("SELECT * FROM travelimage LEFT JOIN (SELECT ImageID FROM travelimagefavor WHERE UID = ?) " +
                        "AS tb ON tb.ImageID = travelimage.ImageID WHERE travelimage.ImageID = tb.ImageID", req.getParameter("uid"));
                int totalPage = ((photos.size() - 1) / pageSize) + 1;
                int currentPage = 1;
                int[] startEndPage = Utils.getStartEndPage(currentPage, totalPage);
                String ajaxStatement = "uid=" + req.getParameter("uid") + "&totalPage=" + totalPage + "&ifFriend=true&";
                String friendName = Utils.getUserName(photoDAO, Integer.parseInt(req.getParameter("uid")));
                boolean ifHideFavor = photoDAO.searchItem("SELECT IfHideFavor FROM traveluser WHERE UID = ?",req.getParameter("uid"));
                req.setAttribute("IfHideFavor",ifHideFavor);
                req.setAttribute("FriendName", friendName);
                req.setAttribute("Photos", photos.subList(0, Math.min(pageSize, photos.size())));
                req.setAttribute("AjaxStatement", ajaxStatement);
                req.setAttribute("CurrentPage", currentPage);
                req.setAttribute("TotalPage", totalPage);
                req.setAttribute("StartPage", startEndPage[0]);
                req.setAttribute("EndPage", startEndPage[1]);
                req.getRequestDispatcher("/pages/favor.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}