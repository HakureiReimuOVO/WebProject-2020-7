package servlet.service;

import DAO.MessageDAO;
import bean.Message;
import utils.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/ChatService")
public class ChatServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            MessageDAO messageDAO = new MessageDAO();
            int fromUID = Integer.parseInt(req.getParameter("FromUID"));
            int toUID = Integer.parseInt(req.getParameter("ToUID"));
            List<Message> messages;
            if (req.getParameter("method") != null) {
                String content = req.getParameter("content");
                Timestamp date = Utils.getCurrentTimestamp();
                messageDAO.updateDatabase("INSERT INTO travelusermessage (FromUID, ToUID, Content, DateSent) VALUES (?, ?, ?, ?)", fromUID, toUID, content, date);
                messages = messageDAO.searchMessages("SELECT * FROM travelusermessage WHERE (FromUID = ? AND ToUID = ?) OR (FromUID = ? AND ToUID = ?)",
                        fromUID, toUID, toUID, fromUID);
                if (messages.size() > 50) messages = messages.subList(messages.size() - 50, messages.size());
            } else {
                messages = messageDAO.searchMessages("SELECT * FROM travelusermessage WHERE (FromUID = ? AND ToUID = ?) OR (FromUID = ? AND ToUID = ?)",
                        fromUID, toUID, toUID, fromUID);
                if (messages.size() > 50) messages = messages.subList(messages.size() - 50, messages.size());
            }
            req.setAttribute("Messages", messages);
            req.getRequestDispatcher("/ajax/chatAjax.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
