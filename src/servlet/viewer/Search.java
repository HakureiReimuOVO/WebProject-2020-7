package servlet.viewer;

import DAO.PhotoDAO;
import bean.Photo;
import utils.Utils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class Search extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().setAttribute("LastPage", req.getContextPath() + "/search");
        req.getRequestDispatcher("/pages/search.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            PhotoDAO photoDAO = new PhotoDAO();
            String item = (req.getParameter("searchType").equals("title")) ? "Title" : "Content";
            boolean isDate = req.getParameter("orderType").equals("date");
            String content = req.getParameter("searchContent");
            int pageSize = 5;
            String sql;
            if (req.getParameter("page") != null) {
                int currentPage = Integer.parseInt(req.getParameter("page"));
                int totalPage = Integer.parseInt(req.getParameter("totalPage"));
                int[] startEndPage = Utils.getStartEndPage(currentPage,totalPage);
                if (isDate) {
                    sql = "SELECT * FROM travelimage WHERE " + item + " LIKE ? ORDER BY DateLastModified DESC LIMIT ?, ?";
                } else {
                    sql = "SELECT * FROM travelimage LEFT JOIN (SELECT COUNT(1),ImageID AS ID FROM travelimagefavor GROUP BY ID) " +
                            "AS tb ON tb.ID = travelimage.ImageID WHERE " + item + " LIKE ? ORDER BY `COUNT(1)` DESC LIMIT ?, ?";
                }
                List<Photo> photos = photoDAO.searchPhotos(sql, "%" + content + "%", (currentPage - 1) * pageSize, pageSize);
                req.setAttribute("Photos", photos);
                req.setAttribute("CurrentPage",currentPage);
                req.setAttribute("TotalPage",totalPage);
                req.setAttribute("StartPage",startEndPage[0]);
                req.setAttribute("EndPage",startEndPage[1]);
                req.getRequestDispatcher("/ajax/searchAjax.jsp").forward(req, resp);
            } else {
                if (isDate) {
                    sql = "SELECT * FROM travelimage WHERE " + item + " LIKE ? ORDER BY DateLastModified DESC";
                } else {
                    sql = "SELECT * FROM travelimage LEFT JOIN (SELECT COUNT(1),ImageID AS ID FROM travelimagefavor GROUP BY ID) " +
                            "AS tb ON tb.ID = travelimage.ImageID WHERE " + item + " LIKE ? ORDER BY `COUNT(1)` DESC";
                }
                List<Photo> photos = photoDAO.searchPhotos(sql, "%" + content + "%");
                int totalPage = ((photos.size() - 1) / pageSize) + 1;
                int currentPage = 1;
                int[] startEndPage = Utils.getStartEndPage(currentPage,totalPage);
                String ajaxStatement = "searchType=" + req.getParameter("searchType") + "&orderType=" + req.getParameter("orderType")
                        + "&searchContent=" + req.getParameter("searchContent") + "&totalPage=" + totalPage + "&";
                req.setAttribute("Photos", photos.subList(0, Math.min(pageSize, photos.size())));
                req.setAttribute("AjaxStatement", ajaxStatement);
                req.setAttribute("CurrentPage",currentPage);
                req.setAttribute("TotalPage",totalPage);
                req.setAttribute("StartPage",startEndPage[0]);
                req.setAttribute("EndPage",startEndPage[1]);
                req.getRequestDispatcher("/pages/search.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
