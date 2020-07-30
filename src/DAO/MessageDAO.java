package DAO;

import bean.Message;
import bean.Photo;
import utils.Utils;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MessageDAO extends DAO {

    public MessageDAO() throws SQLException {

    }

    public Message searchMessage(String sql, Object... args) throws SQLException {
        Map<String, Object> result = super.searchResult(sql, args);
        Message message = getMessageByMap(result);
        return message;
    }

    public List<Message> searchMessages(String sql, Object... args) throws SQLException {
        List<Map<String, Object>> results = super.searchResults(sql, args);
        List<Message> messages = new ArrayList<>();
        for (Map<String, Object> result : results) {
            messages.add(getMessageByMap(result));
        }
        return messages;
    }

    private Message getMessageByMap(Map<String, Object> result) throws SQLException {
        Message message = new Message();
        if (result.get("MessageID") != null) message.setMessageID((int) result.get("MessageID"));
        if ((result.get("FromUID")) != null) {
            message.setFromID((int) result.get("FromUID"));
            message.setFromName(Utils.getUserName(this, (int) result.get("FromUID")));
        }
        if ((result.get("ToUID")) != null)
            message.setToID((int) result.get("ToUID"));
        if (result.get("Content") != null) message.setContent((String) result.get("Content"));
        if (result.get("DateSent") != null) message.setDateSent((Timestamp) result.get("DateSent"));
        return message;
    }
}