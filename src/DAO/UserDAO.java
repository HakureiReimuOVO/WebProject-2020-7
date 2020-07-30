package DAO;

import bean.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class UserDAO extends DAO {

    public UserDAO() throws SQLException {

    }

    public User searchUser(String sql, Object... args) throws SQLException {
        Map<String, Object> result = super.searchResult(sql, args);
        User user = getUserByMap(result);
        return user;
    }

    public List<User> searchUsers(String sql, Object... args) throws SQLException {
        List<Map<String, Object>> results = super.searchResults(sql, args);
        List<User> users = new ArrayList<>();
        for (Map<String, Object> result : results) {
            users.add(getUserByMap(result));
        }
        return users;
    }

    private User getUserByMap(Map<String, Object> result) {
        User user = new User();
        if (result.get("UID") != null) user.setUID((int) result.get("UID"));
        if (result.get("UserName") != null) user.setUserName((String) result.get("UserName"));
        if (result.get("Password") != null) user.setPassword((String) result.get("Password"));
        if (result.get("Email") != null) user.setEmail((String) result.get("Email"));
        if (result.get("DateJoined") != null) user.setDateJoined((Timestamp) result.get("DateJoined"));
        if (result.get("DateLastModified") != null) user.setDateLastModified((Timestamp) result.get("DateLastModified"));
        if (result.get("IfHideFavor") != null) user.setIfHideFavor((boolean) result.get("IfHideFavor"));
        return user;
    }
}
